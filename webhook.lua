local json = require("json")



    if doauradetection ~= nil then
        doauradetection = doauradetection
    end
webhookurl = ""
censored = ""
censoredsave = ""
loadSettings()

webhookButtonHitbox = {
    x = 390,
    y = 95,
    w = 160,
    h = 30
}

function drawWebhook()
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    drawCornerBox(230, 10, 500, 30)
drawCornerBox(230, 50, 500, 40)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("WEBHOOK", 420, 10)
    

    love.graphics.setScissor(230, 50, 490, 50)
    love.graphics.print(censored, 230, 60)
    love.graphics.setScissor() -- reset, or it clips everything drawn after this

    love.graphics.setColor(0, 1, 0, 0.5)
    drawCornerBox(390, 95, 160, 30)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Test webhook", 395, 95)
    love.graphics.print("LeftCtrl + C to copy the whole URL, LeftCtrl + V to paste and LeftAlt + L to uncensor.", 75 , 500)
end