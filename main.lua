local ffi = require("ffi")

ffi.cdef[[
    typedef void* HWND;
    typedef int BOOL;
    
    HWND FindWindowA(const char* lpClassName, const char* lpWindowName);

    typedef long HRESULT;

    HRESULT DwmSetWindowAttribute(
        HWND hwnd,
        unsigned int dwAttribute,
        const void* pvAttribute,
        unsigned int cbAttribute
    );
]]

local user32 = ffi.load("user32")
local dwmapi = ffi.load("dwmapi")
love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";?.lua;?/init.lua")
love.filesystem.setCRequirePath(love.filesystem.getCRequirePath() .. ";?.dll")
local http = require("ssl.https")
print("1: main started")
warningtext = "temporaryplaceholder"

local ok, result = pcall(require, "ssl.https")

print("2: require finished")
print("OK:", ok)
print("RESULT:", result)

if not ok then
    error(result)
end
songstate = "play bgm?"
tabmenuX = 5

currentTab = "maincontrols"
function love.run() -- for anyone reading the source code, you may be wondering why i put a 60 fps limit on this, why the fuck would you want 240 fps on a macro app have some common sense dawg.

    if love.load then love.load(arg) end

    if love.timer then love.timer.step() end

    local dt = 0
    local targetFPS = 60
    local minDt = 1 / targetFPS

    return function()
        local frameStartTime = love.timer.getTime()

        if love.event then
            love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return arg or 0
                    end
                end
                love.handlers[name](a, b, c, d, e, f)
            end
        end

        if love.timer then dt = love.timer.step() end

        if love.update then love.update(dt) end

        if love.graphics and love.graphics.isActive() then
            love.graphics.clear(love.graphics.getBackgroundColor())
            love.graphics.origin()
            if love.draw then love.draw() end
            love.graphics.present()
        end

        local frameDuration = love.timer.getTime() - frameStartTime
        if frameDuration < minDt then
            love.timer.sleep(minDt - frameDuration)
        end
    end
end
local fontPaths = {
    regular = "assets/fonts/Sarpanch-Regular.ttf",
    medium = "assets/fonts/Sarpanch-Medium.ttf",
    semibold = "assets/fonts/Sarpanch-SemiBold.ttf",
    bold = "assets/fonts/Sarpanch-Bold.ttf",
    extrabold = "assets/fonts/Sarpanch-ExtraBold.ttf",
    black = "assets/fonts/Sarpanch-Black.ttf"
}


menuHitbox = {
    x = tabmenuX - 5,
    y = 5,
    w = 25,
    h = 22
}

local fonts = {}

function love.load()
    loadSettings()
    fonts.bold20 = love.graphics.newFont(fontPaths.bold, 20)
end

function fontconfig()
    love.graphics.setFont(fonts.bold20)
end

local width = 1000
local height = 600

function love.draw()
    love.graphics.clear(0.2,0.2,0.2,0.5)
    fontconfig("bold", 20)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.print(
        "Welcome, " .. os.getenv("USERNAME") .. "!",
        750,
        0
    )
        love.graphics.print(
        songstate,
        880,
        30)
songHitbox = {
    x = 880,
    y = 30,
    w = 100,
    h = 25
}

    -- corners
    love.graphics.rectangle("fill", 5, 5, 20, 2)
    love.graphics.rectangle("fill", 5, 5, 2, 20)

    love.graphics.rectangle("fill", width - 25, 5, 20, 2)
    love.graphics.rectangle("fill", width - 7, 5, 2, 20)

    love.graphics.rectangle("fill", 5, height - 7, 20, 2)
    love.graphics.rectangle("fill", 5, height - 25, 2, 20)

    love.graphics.rectangle("fill", width - 25, height - 7, 20, 2)
    love.graphics.rectangle("fill", width - 7, height - 25, 2, 20)

    -- tabmenu
    love.graphics.line(tabmenuX, 10, tabmenuX + 15, 10)
    love.graphics.line(tabmenuX, 16, tabmenuX + 15, 16)
    love.graphics.line(tabmenuX, 22, tabmenuX + 15, 22)
    love.graphics.rectangle("line", tabmenuX - 5, 5, 25, 22)

    -- Main controls box
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    drawCornerBox(
        800,
        60,
        200,
        40
    )
    drawCornerBox(
        tabmenuX - 195,
        5,
        185,
        40
    )
        drawCornerBox(
        tabmenuX - 195, 50,
        185,
        40
    )
        drawCornerBox(
        tabmenuX - 195, 95,
        185,
        40
    )
            drawCornerBox(
        tabmenuX - 195, 140,
        185,
        40
    )
                drawCornerBox(
        tabmenuX - 195, 185,
        185,
        40
    )
                    drawCornerBox(
        tabmenuX - 195, 230,
        185,
        40
    )
                        drawCornerBox(
        tabmenuX - 195, 275,
        185,
        40
    )
    drawCornerBox (warningx - 500, 560, 500, 40)

    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.print(
        "Main controls",
        tabmenuX - 180,
        10
    )
    love.graphics.print("Save settings?",
        825,
        65 

    )
        love.graphics.print(
        "Webhook",
        tabmenuX - 180,
        55
    )
            love.graphics.print(
        "Aura detection",
        tabmenuX - 180,
        100
    )
                love.graphics.print(
        "Biome detection",
        tabmenuX - 185,
        145
    )
                    love.graphics.print(
        "Fishing (soon)",
        tabmenuX - 185,
        190
    )
                        love.graphics.print(
        "Credits",
        tabmenuX - 185,
        235
    )
                            love.graphics.print(
        "Licenses",
        tabmenuX - 185,
        280
    )
                                love.graphics.print(
        warningtext,
        warningx - 490,
        565
    )
    
    if currentTab == "maincontrols" then
        drawMainControls()

    elseif currentTab == "webhook" then
        drawWebhook()

    elseif currentTab == "aura" then
        drawAura()

    elseif currentTab == "biome" then
        drawBiome()

    elseif currentTab == "fishing" then
        drawFishing()

    elseif currentTab == "credits" then
        drawCredits()

    elseif currentTab == "licenses" then
        drawLicenses()
    end
end

require("functions")
require("maincontrols")
require("webhook")
require("aura")
require("biome")
require("fishing")
require("credits")
require("licenses")