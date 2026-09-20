warningx = -500
warningTarget = 0
doauradetection = false
local json = require("json")
function loadSettings()
    if love.filesystem.getInfo("settings.json") then
        local contents = love.filesystem.read("settings.json")
        local settings = json.decode(contents)

        if settings then
            donormalbiomedetection = settings.donormalbiomedetection or false
dowindybiomedetection = settings.dowindybiomedetection or false
dosnowybiomedetection = settings.dosnowybiomedetection or false
dorainybiomedetection = settings.dorainybiomedetection or false
dosandstormbiomedetection = settings.dosandstormbiomedetection or false
dohellbiomedetection = settings.dohellbiomedetection or false
dostarfallbiomedetection = settings.dostarfallbiomedetection or false
doheavenbiomedetection = settings.doheavenbiomedetection or false
docorruptionbiomedetection = settings.docorruptionbiomedetection or false
donullbiomedetection = settings.donullbiomedetection or false
dosingularitybiomedetection = settings.dosingularitybiomedetection or false
doblazingsunbiomedetection = settings.doblazingsunbiomedetection or false
            webhookurl = settings.webhookurl or ""
            privateServerLink = settings.privateServerLink or ""
            censored = string.rep("*", #webhookurl)
            doauradetection = settings.doauradetection or false
        end
    end
end
function love.keypressed(key)

    -- WEBHOOK TAB
    if currentTab == "webhook" then

        if key == "v" and love.keyboard.isDown("lctrl") then
            local clipboard = love.system.getClipboardText()
            webhookurl = webhookurl .. clipboard
            censored = string.rep("*", #webhookurl)

        elseif key == "c" and love.keyboard.isDown("lctrl") then
            love.system.setClipboardText(webhookurl)

        elseif key == "backspace" then
            webhookurl = webhookurl:sub(1, -2)
            censored = censored:sub(1, -2)

        elseif key == "delete" then
            webhookurl = ""
            censored = ""

        elseif key == "l" and love.keyboard.isDown("lalt") then
            censored = webhookurl
        end

    -- BIOME TAB
    elseif currentTab == "biome" then

        if key == "backspace" then
            privateServerLink = privateServerLink:sub(1, -2)

        elseif key == "delete" then
            privateServerLink = ""

        elseif key == "v" and love.keyboard.isDown("lctrl") then
            local clipboard = love.system.getClipboardText()
            privateServerLink = privateServerLink .. clipboard

        elseif key == "c" and love.keyboard.isDown("lctrl") then
            love.system.setClipboardText(privateServerLink)
        end

    end
end


function love.keyreleased(key)

    if key == "l" then
        censored = string.rep("*", #webhookurl)
    end

end


function love.textinput(t)

    if currentTab == "webhook" then

        if not love.keyboard.isDown("lalt")
        and not love.keyboard.isDown("lctrl") then
            webhookurl = webhookurl .. t
            censored = string.rep("*", #webhookurl)
        end

    elseif currentTab == "biome" then

        if not love.keyboard.isDown("lctrl") then
            privateServerLink = privateServerLink .. t
        end

    end

end
 

require("logmonitor")
local handCursor   = love.mouse.getSystemCursor("hand")
local normalCursor = love.mouse.getSystemCursor("arrow")
local tabopenclose  = love.audio.newSource("assets/sounds/coolsound.mp3", "static")
local bgm = love.audio.newSource("assets/sounds/bgm.mp3", "stream")
local bgmnight = love.audio.newSource("assets/sounds/bgmnight.mp3", "stream")
local rew = love.audio.newSource("assets/sounds/rew.mp3", "static")
love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";?.lua;?/init.lua")
love.filesystem.setCRequirePath(love.filesystem.getCRequirePath() .. ";?.dll")
local webhookThread = love.thread.newThread("webhookthread.lua")
webhookThread:start()
local robloxLogsPath = os.getenv("LOCALAPPDATA") .. "\\Roblox\\logs"
local biomeCheckTimer = 0
local logFile = nil
local logPosition = 0


bgm:setLooping(true)
macrostarted = false
local http = require("ssl.https")
local json = require("json")
local ltn12 = require("ltn12")
local menuopen = false


function saveSettings()
    print("saving settings")
local settings = {
    webhookurl = webhookurl,
    doauradetection = doauradetection,
    privateServerLink = privateServerLink,

    donormalbiomedetection = donormalbiomedetection,
    dowindybiomedetection = dowindybiomedetection,
    dosnowybiomedetection = dosnowybiomedetection,
    dorainybiomedetection = dorainybiomedetection,
    dosandstormbiomedetection = dosandstormbiomedetection,
    dohellbiomedetection = dohellbiomedetection,
    dostarfallbiomedetection = dostarfallbiomedetection,
    doheavenbiomedetection = doheavenbiomedetection,
    docorruptionbiomedetection = docorruptionbiomedetection,
    donullbiomedetection = donullbiomedetection,
    dosingularitybiomedetection = dosingularitybiomedetection,
    doblazingsunbiomedetection = doblazingsunbiomedetection
}

    local contents = json.encode(settings)
    love.filesystem.write("settings.json", contents)

    warningtext = "Settings saved!"
    warningTarget = 500
    warningShowing = true
    warningTimer = 3
end
function drawCheckbox(x, y, label, value)
    drawCornerBox(x, y, 40, 40)

    local hitbox = {
        x = x,
        y = y,
        w = 40,
        h = 40
    }

    love.graphics.setColor(1, 1, 1, 1)

    if value == true then
        love.graphics.print("X", x + 12, y + 5)
    end

    love.graphics.print(label, x - 25, y - 25)

    return hitbox
end
function sendtestwebhook(embed, content)
    if webhookurl == "" then
        print("No webhook URL provided.")
        return false
    end
    local payload = {
        embeds = {
            embed
        },
        content = content
    }

    local jsonPayload = json.encode(payload)

    local responseBody, statusCode, responseHeaders, statusLine = http.request {
        url = webhookurl,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#jsonPayload)
        },
        source = ltn12.source.string(jsonPayload)
    }

    if statusCode == 204 then
        print("Webhook sent successfully!")
                        warningtext = "webhook url is valid!"
warningTarget = 500
warningShowing = true
warningTimer = 3
        return true
    else
        print("Failed to send webhook. Status code: " .. tostring(statusCode))
        print("Response: " .. tostring(responseBody))
        warningtext = "Failed to send webhook. Status code: " .. tostring(statusCode)
warningTarget = 500
warningShowing = true
warningTimer = 3
        return false
    end
end

function sendWebhookMessage(embed, content)
    if webhookurl == "" then
        return false
    end

    local channel = love.thread.getChannel("webhookQueue")

    channel:push({
        url = webhookurl,
        embed = embed,
        content = content
    })

    return true
end

    local jsonPayload = json.encode(payload)


function testWebhook()
    sendtestwebhook(nil, "test")
end

local function pointInBox(px, py, box)
    if not box then
        return false
    end

    return px >= box.x and px <= box.x + box.w
       and py >= box.y and py <= box.y + box.h
end

local function isOverMenu(mx, my)
    return pointInBox(mx - tabmenuX, my, menuHitbox)
end

function love.mousepressed(x, y, button)
    
    if button ~= 1 then return end
        if pointInBox(x, y, savesettingshitbox) then
        rew:clone():play()
        saveSettings()
    end
    if pointInBox(x, y, doauradetectionbuttonhitbox) and currentTab == "aura" then
        if doauradetection == false then
            doauradetection = true
            rew:clone():play()
        else
            doauradetection = false
            rew:clone():play()
        end
    end
    
    -- Menu button
    if isOverMenu(x, y) then
        local playingsound = tabopenclose:clone()
        playingsound:play()
        menuopen = not menuopen
    end
    bgmnight:setLooping(true)
    -- Song button
local t = os.date("*t")
local seconds = t.hour * 3600 + t.min * 60 + t.sec
    if pointInBox(x, y, songHitbox) then
        if songstate == "play bgm?" then
            if seconds >= 0 and seconds <= 18000 then
                bgmnight:play()
            else
                bgm:play()
            end
            rew:clone():play()
            songstate = "stop bgm?"
        else
            if bgmnight:isPlaying() == true then
                bgmnight:stop()
            else
                bgm:stop()
            end
            rew:clone():play()
            songstate = "play bgm?"
        end
    end

    -- Tabs
    if pointInBox(x, y, mainControlsHitbox) then
        currentTab = "maincontrols"
        rew:clone():play()

    elseif pointInBox(x, y, webhookHitbox) then
        currentTab = "webhook"
        rew:clone():play()

    elseif pointInBox(x, y, auraHitbox) then
        currentTab = "aura"
        rew:clone():play()

    elseif pointInBox(x, y, biomeHitbox) then
        currentTab = "biome"
        rew:clone():play()

    elseif pointInBox(x, y, fishingHitbox) then
        currentTab = "fishing"
        rew:clone():play()

    elseif pointInBox(x, y, creditsHitbox) then
        currentTab = "credits"
        rew:clone():play()

    elseif pointInBox(x, y, licensesHitbox) then
        currentTab = "licenses"
        rew:clone():play()
    end
    if pointInBox(x, y, normalBiomeHitbox) then
    donormalbiomedetection = not donormalbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, windyBiomeHitbox) then
    dowindybiomedetection = not dowindybiomedetection
    rew:clone():play()
end

if pointInBox(x, y, snowyBiomeHitbox) then
    dosnowybiomedetection = not dosnowybiomedetection
    rew:clone():play()
end

if pointInBox(x, y, rainyBiomeHitbox) then
    dorainybiomedetection = not dorainybiomedetection
    rew:clone():play()
end

if pointInBox(x, y, sandstormBiomeHitbox) then
    dosandstormbiomedetection = not dosandstormbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, hellBiomeHitbox) then
    dohellbiomedetection = not dohellbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, starfallBiomeHitbox) then
    dostarfallbiomedetection = not dostarfallbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, heavenBiomeHitbox) then
    doheavenbiomedetection = not doheavenbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, corruptionBiomeHitbox) then
    docorruptionbiomedetection = not docorruptionbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, nullBiomeHitbox) then
    donullbiomedetection = not donullbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, singularityBiomeHitbox) then
    dosingularitybiomedetection = not dosingularitybiomedetection
    rew:clone():play()
end

if pointInBox(x, y, blazingSunBiomeHitbox) then
    doblazingsunbiomedetection = not doblazingsunbiomedetection
    rew:clone():play()
end

    if currentTab == "maincontrols" then
    if pointInBox(x, y, startButtonHitbox) then

    if macrostarted == false then
        sendWebhookMessage({
    title = os.date("%d.%m.%Y %H:%M:%S"),
    description = "# Macro started!"
    ,
    color = 0x02f042,

    thumbnail = {
        url = "https://raw.githubusercontent.com/finnsgthbthingy/stuff/main/luasol.png"
    },

    footer = {
        text = "LuaSol v1.0"
    }
}, nil)
        macrostarted = true
        checkBiome()
        warningtext = "Macro started!"
warningTarget = 500
warningShowing = true
warningTimer = 3
        

        rew:clone():play()
    else
        sendWebhookMessage({
    title = os.date("%d.%m.%Y %H:%M:%S"),
    description = "# Macro stopped!"
    ,
    color = 0xf0020a,

    thumbnail = {
        url = "https://raw.githubusercontent.com/finnsgthbthingy/stuff/main/luasol.png"
    },

    footer = {
        text = "LuaSol v1.0"
    }
}, nil)
        macrostarted = false
        
        if logFile then
            logFile:close()
            logFile = nil
        end

        rew:clone():play()
    end
end
end
    -- Test webhook
    if pointInBox(x, y, webhookButtonHitbox) then
        if currentTab ==  "webhook" then
        testWebhook()
        rew:clone():play()
    end
end
end
    local memTimer = 0
function love.update(dt)


  local speed = 2.5

    if warningTarget == -500 then
        speed = 1.0
    end



    if warningShowing then
        warningTimer = warningTimer - dt

        if warningTimer <= 0 then
            warningTarget = -500
            warningShowing = false
        end
    end
    memTimer = memTimer + dt

    if memTimer >= 5 then
        memTimer = 0

        print(string.format(
            "Lua heap: %.2f MB",
            collectgarbage("count") / 1024
        ))
    end

if macrostarted == true then
    biomeCheckTimer = biomeCheckTimer + dt

    if biomeCheckTimer >= 1 then
        biomeCheckTimer = 0
        print("using" .. robloxLogsPath .. "\\*.log")
        print("[LuaSol] CHECKING LOG...")
        checkBiome()
    end
else
    biomeCheckTimer = 0
end
local target = menuopen and 200 or 9
tabmenuX = tabmenuX + (target - tabmenuX) * 10 * dt
    warningx = warningx + (warningTarget - warningx) * 2 * dt

    mainControlsHitbox.x = tabmenuX - 195
    webhookHitbox.x = tabmenuX - 195
    auraHitbox.x = tabmenuX - 195
    biomeHitbox.x = tabmenuX - 195
    fishingHitbox.x = tabmenuX - 195
    creditsHitbox.x = tabmenuX - 195
    licensesHitbox.x = tabmenuX - 195
    local mx, my = love.mouse.getPosition()

    if isOverMenu(mx, my)
    or pointInBox(mx, my, savesettingshitbox)
    or pointInBox(mx, my, mainControlsHitbox)
    or pointInBox(mx, my, doauradetectionbuttonhitbox) and currentTab == "aura"
    or pointInBox(mx, my, startButtonHitbox) and currentTab == "maincontrols"
    or pointInBox(mx, my, webhookButtonHitbox) and currentTab == "webhook"
    or pointInBox(mx, my, webhookHitbox)
    or pointInBox(mx, my, auraHitbox)
    or pointInBox(mx, my, biomeHitbox)
    or pointInBox(mx, my, fishingHitbox)
    or pointInBox(mx, my, creditsHitbox)
    or pointInBox(mx, my, licensesHitbox)
    or pointInBox(mx, my, songHitbox) then

        love.mouse.setCursor(handCursor)
    else
        love.mouse.setCursor(normalCursor)
    end
end
function drawCornerBox(x, y, w, h)
        love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", x, y, w, h)

        love.graphics.setColor(0,0,0,0.5)
    -- Main fill
    love.graphics.rectangle("fill", x + 2, y + 2, w - 4, h - 4)

    -- Outline

    

    -- Corner decorations
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", x + 2, y + 2, 10, 2)
    love.graphics.rectangle("fill", x + 2, y + 2, 2, 10)

    love.graphics.rectangle("fill", x + w - 12, y + 2, 10, 2)
    love.graphics.rectangle("fill", x + w - 4, y + 2, 2, 10)

    love.graphics.rectangle("fill", x + 2, y + h - 4, 10, 2)
    love.graphics.rectangle("fill", x + 2, y + h - 12, 2, 10)

    love.graphics.rectangle("fill", x + w - 12, y + h - 4, 10, 2)
    love.graphics.rectangle("fill", x + w - 4, y + h - 12, 2, 10)

    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
end
savesettingshitbox = {
    x = 800,
     y =   60,
     w=   200,
     h=   40
}
mainControlsHitbox = {
    x = tabmenuX - 195,
    y = 5,
    w = 185,
    h = 40
}

webhookHitbox = {
    x = tabmenuX - 195,
    y = 50,
    w = 185,
    h = 40
}

auraHitbox = {
    x = tabmenuX - 195,
    y = 95,
    w = 185,
    h = 40
}

biomeHitbox = {
    x = tabmenuX - 195,
    y = 140,
    w = 185,
    h = 40
}

fishingHitbox = {
    x = tabmenuX - 195,
    y = 185,
    w = 185,
    h = 40
}

creditsHitbox = {
    x = tabmenuX - 195,
    y = 230,
    w = 185,
    h = 40
}

licensesHitbox = {
    x = tabmenuX - 195,
    y = 275,
    w = 185,
    h = 40
}
startButtonHitbox = {
    x = 400,
    y = 45,
    w = 160,
    h = 30
}
