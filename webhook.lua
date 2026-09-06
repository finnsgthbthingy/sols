local json = require("json")



    if doauradetection ~= nil then
        doauradetection = doauradetection
    end
webhookurl = ""
censored = ""
censoredsave = ""
loadSettings()

webhookButtonHitbox = {
    x = 300,
    y = 150,
    w = 160,
    h = 30
}

function love.keypressed(key)
    if key == "v" and love.keyboard.isDown("lctrl") then
        if currentTab == "webhook" then
        local clipboard = love.system.getClipboardText()
        webhookurl = webhookurl .. clipboard
        censored = string.rep("*", #webhookurl)
        end
    end
        if key == "c" and love.keyboard.isDown("lctrl") then
            if currentTab == "webhook" then
    love.system.setClipboardText(webhookurl)
            end
        end





    if key == "backspace" then
        if currentTab == "webhook" then
        webhookurl = webhookurl:sub(1, -2)
        censored = censored:sub(1, -2)
        end
    end
    if key == "delete" then
        if currentTab == "webhook" then
        webhookurl = ""
        censored = ""
        end
    end
    if key == "l" and love.keyboard.isDown("lalt") then

        censored = webhookurl 

    end
end

function love.keyreleased(key)

    if key == "l" then
        censored = string.rep("*", #webhookurl)
    end
end

function love.textinput(t)
    if currentTab == "webhook" then
    if not love.keyboard.isDown("lalt") and not love.keyboard.isDown("lctrl") then
        webhookurl = webhookurl .. t
        censored = string.rep("*", #webhookurl)
    end
    end
end

function drawWebhook()
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    drawCornerBox(230, 10, 500, 30)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("WEBHOOK", 400, 10)

    love.graphics.rectangle("line", 195, 100, 600, 40)

    love.graphics.setScissor(195, 100, 600, 40)
    love.graphics.print(censored, 205, 110)
    love.graphics.setScissor() -- reset, or it clips everything drawn after this

    love.graphics.setColor(0, 1, 0, 0.5)
    drawCornerBox(300, 150, 160, 30)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Test webhook", 305, 150)
    love.graphics.print("LeftCtrl + C to copy the whole URL, LeftCtrl + V to paste and LeftAlt + L to uncensor.", 75 , 500)
end