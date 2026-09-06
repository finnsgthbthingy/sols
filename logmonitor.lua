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
local biomeIcons = {
    NORMAL = "https://static.wikia.nocookie.net/sol-rng/images/0/07/DISCORICH-NORMAL.png/revision/latest?cb=20260823042008",
    WINDY = "https://static.wikia.nocookie.net/sol-rng/images/9/98/DISCORICH-WINDY.png/revision/latest?cb=20260823041210",
    SNOWY = "https://static.wikia.nocookie.net/sol-rng/images/8/86/DISCORICH-SNOWY.png/revision/latest?cb=20260823041153",
    RAINY = "https://static.wikia.nocookie.net/sol-rng/images/7/77/DISCORICH-RAINY.png/revision/latest?cb=20260823042833",
    SANDSTORM = "https://static.wikia.nocookie.net/sol-rng/images/9/92/DISCORICH-SANDSTORM.png/revision/latest?cb=20260823202219",
    HELL = "https://static.wikia.nocookie.net/sol-rng/images/b/b9/DISCORICH-HELL.png/revision/latest?cb=20260823044812",
    STARFALL = "https://static.wikia.nocookie.net/sol-rng/images/1/11/DISCORICH-STARFALL.png/revision/latest?cb=20260823041135",
    HEAVEN = "https://static.wikia.nocookie.net/sol-rng/images/f/f9/Heaven.png/revision/latest?cb=20260616013200",
    CORRUPTION = "https://static.wikia.nocookie.net/sol-rng/images/5/5f/DISCORICH-CORRUPTION.png/revision/latest?cb=20260823224417",
    NULL = "https://static.wikia.nocookie.net/sol-rng/images/b/bb/Null_Biome_%28BloxTrap%29.png/revision/latest?cb=20250311003954",
    DREAMSPACE = "https://static.wikia.nocookie.net/sol-rng/images/7/7a/DreamspaceRichPresenceFIX.png/revision/latest?cb=20251008202603",
    SINGULARITY = "https://static.wikia.nocookie.net/sol-rng/images/1/13/Singularity_Bloxstrap.png/revision/latest?cb=20260621141103",
    GLITCHED = "https://static.wikia.nocookie.net/sol-rng/images/d/dc/DISCORICH-BROKEN.png/revision/latest?cb=20260823042244", --couldnt find the official one :c
    CYBERSPACE = "https://static.wikia.nocookie.net/sol-rng/images/d/dc/DISCORICH-BROKEN.png/revision/latest?cb=20260823042244" --same reason as glitched
}
local everyoneping = ""
if biome == "GLITCHED" or biome == "DREAMSPACE" or biome == "CYBERSPACE" then
    everyoneping = "@everyone"
else
    everyoneping = ""
end
local iconURL = biomeIcons[biome]
sendWebhookMessage({
    title = os.date("%d.%m.%Y %H:%M:%S"),
    description = "# Biome Started - **" .. biome .. "**",
    color = 0x3498DB,

    thumbnail = {
        url = iconURL
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