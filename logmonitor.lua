local json = require("json")
local robloxLogsPath = os.getenv("LOCALAPPDATA") .. "\\Roblox\\logs"

local biomeCheckTimer = 0
local prevBiome = "None"
local prevState = "None"

currentBiome = "None"
currentEquipped = "None"

function getLatestRobloxLog()
    local ffi = require("ffi")

    ffi.cdef[[
        typedef void* HANDLE;
        typedef unsigned long DWORD;
        typedef int BOOL;
        typedef struct {
            DWORD dwLowDateTime;
            DWORD dwHighDateTime;
        } FILETIME;

        typedef struct {
            DWORD dwFileAttributes;
            FILETIME ftCreationTime;
            FILETIME ftLastAccessTime;
            FILETIME ftLastWriteTime;
            DWORD nFileSizeHigh;
            DWORD nFileSizeLow;
            DWORD dwReserved0;
            DWORD dwReserved1;
            char cFileName[260];
            char cAlternateFileName[14];
        } WIN32_FIND_DATAA;

        HANDLE FindFirstFileA(
            const char* lpFileName,
            WIN32_FIND_DATAA* lpFindFileData
        );

        BOOL FindNextFileA(
            HANDLE hFindFile,
            WIN32_FIND_DATAA* lpFindFileData
        );

        BOOL FindClose(HANDLE hFindFile);
    ]]

    local INVALID_HANDLE_VALUE = ffi.cast("HANDLE", -1)

    local searchPath = robloxLogsPath .. "\\*.log"

    local data = ffi.new("WIN32_FIND_DATAA")
    local handle = ffi.C.FindFirstFileA(searchPath, data)

    if handle == INVALID_HANDLE_VALUE then
        return nil
    end

    local newestFile = nil
    local newestHigh = 0
    local newestLow = 0

    repeat
        local name = ffi.string(data.cFileName)

        local high = tonumber(data.ftLastWriteTime.dwHighDateTime)
        local low = tonumber(data.ftLastWriteTime.dwLowDateTime)

        if not newestFile
        or high > newestHigh
        or (high == newestHigh and low > newestLow) then
            newestFile = name
            newestHigh = high
            newestLow = low
        end
    until ffi.C.FindNextFileA(handle, data) == 0

    ffi.C.FindClose(handle)

    if not newestFile then
        return nil
    end

    return robloxLogsPath .. "\\" .. newestFile
end

function parseBloxstrapRPC(line)
    local jsonStart = line:find("{")

    if not jsonStart then
        return
    end

    local jsonText = line:sub(jsonStart)
    local data = json.decode(jsonText)

    if not data or data.command ~= "SetRichPresence" then
        return
    end

    if not data.data then
        return
    end

    local state = data.data.state
    local biome = nil

    if data.data.largeImage then
        biome = data.data.largeImage.hoverText
    end


    -- BIOME
if biome and biome ~= "" and biome ~= prevBiome then
    currentBiome = biome
    prevBiome = biome
local biomes = {
    NORMAL = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/0/07/DISCORICH-NORMAL.png/revision/latest?cb=20260823042008",
        color = 0x3498DB
    },

    WINDY = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/9/98/DISCORICH-WINDY.png/revision/latest?cb=20260823041210",
        color = 0x2ECC71
    },

    SNOWY = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/8/86/DISCORICH-SNOWY.png/revision/latest?cb=20260823041153",
        color = 0xFFFFFF
    },

    RAINY = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/7/77/DISCORICH-RAINY.png/revision/latest?cb=20260823042833",
        color = 0x1f299c
    },

    SANDSTORM = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/9/92/DISCORICH-SANDSTORM.png/revision/latest?cb=20260823202219",
        color = 0xE5B96B
    },

    HELL = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/b/b9/DISCORICH-HELL.png/revision/latest?cb=20260823044812",
        color = 0xf51700
    },

    STARFALL = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/1/11/DISCORICH-STARFALL.png/revision/latest?cb=20260823041135",
        color = 0x00179c
    },

    HEAVEN = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/f/f9/Heaven.png/revision/latest?cb=20260616013200",
        color = 0xF1C40F
    },

    CORRUPTION = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/5/5f/DISCORICH-CORRUPTION.png/revision/latest?cb=20260823224417",
        color = 0x480166
    },

    NULL = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/b/bb/Null_Biome_%28BloxTrap%29.png/revision/latest?cb=20250311003954",
        color = 0x000000
    },

    DREAMSPACE = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/7/7a/DreamspaceRichPresenceFIX.png/revision/latest?cb=20251008202603",
        color = 0xFF69B4
    },

    SINGULARITY = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/1/13/Singularity_Bloxstrap.png/revision/latest?cb=20260621141103",
        color = 0xff7300
    },

    GLITCHED = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/d/dc/DISCORICH-BROKEN.png/revision/latest?cb=20260823042244",
        color = 0x303336
    },

    CYBERSPACE = {
        icon = "https://static.wikia.nocookie.net/sol-rng/images/d/dc/DISCORICH-BROKEN.png/revision/latest?cb=20260823042244",
        color = 0x020030
    },
    ["BLAZING SUN"] = {
        icon = "https://raw.githubusercontent.com/vexsyx/OysterDetector/refs/heads/main/assets/blazing%20sun.png",
        color = 0xfcba03
    }
}

biomedata = biomes[biome]

local shouldDetect = false

if biome == "NORMAL" then
    shouldDetect = donormalbiomedetection
elseif biome == "WINDY" then
    shouldDetect = dowindybiomedetection
elseif biome == "SNOWY" then
    shouldDetect = dosnowybiomedetection
elseif biome == "RAINY" then
    shouldDetect = dorainybiomedetection
elseif biome == "SANDSTORM" then
    shouldDetect = dosandstormbiomedetection
elseif biome == "HELL" then
    shouldDetect = dohellbiomedetection
elseif biome == "STARFALL" then
    shouldDetect = dostarfallbiomedetection
elseif biome == "HEAVEN" then
    shouldDetect = doheavenbiomedetection
elseif biome == "CORRUPTION" then
    shouldDetect = docorruptionbiomedetection
elseif biome == "NULL" then
    shouldDetect = donullbiomedetection
elseif biome == "SINGULARITY" then
    shouldDetect = dosingularitybiomedetection
elseif biome == "BLAZING SUN" then
    shouldDetect = doblazingsunbiomedetection
end

if shouldDetect and biomedata then
    local everyoneping = ""

    if biome == "GLITCHED"
    or biome == "DREAMSPACE"
    or biome == "CYBERSPACE" then
        everyoneping = "@everyone"
    end
end
    sendWebhookMessage({
        title = os.date("%d.%m.%Y %H:%M:%S"),

        description = "> ### Biome Started - " .. biome ..
                      "\n> ### [Join Server](" .. privateServerLink .. ")",

        color = biomedata.color,

        thumbnail = {
            url = biomedata.icon
        },

        footer = {
            text = "LuaSol v1.0"
        }
    }, everyoneping)
end
    -- AURA
    if state
    and state ~= ""
    and state ~= "In Main Menu"
    and state ~= "Equipped _None_"
    and state ~= prevState then

        local auraName = state

        -- JSON has already been decoded, so NO backslashes here
        local extracted = state:match('Equipped "(.-)"')

        if extracted then
            auraName = extracted
        end

        currentEquipped = auraName
        prevState = state
if doauradetection == true then
sendWebhookMessage{
    title = os.date("%d.%m.%Y %H:%M:%S"),
    description = "# Aura Equipped ** - " .. auraName .. "**.",
    color = 0xFFEE8C,

    footer = {
        text = "LuaSol v1.0"
    }
}
    end
end
end


function checkBiome()
    local newestLog = getLatestRobloxLog()

    if not newestLog then
        return
    end

    local file = io.open(newestLog, "rb")

    if not file then
        return
    end

    local size = file:seek("end")

    if not size then
        file:close()
        return
    end

    local chunkSize = 10240
    local startPosition = math.max(0, size - chunkSize)

    file:seek("set", startPosition)

    local content = file:read("*a")
    file:close()

    if not content then
        return
    end

    local lastRPC = nil

    for line in content:gmatch("[^\r\n]+") do
        if line:find("%[BloxstrapRPC%]") then
            lastRPC = line
        end
    end

    if lastRPC then
        parseBloxstrapRPC(lastRPC)
    end
end