function drawAura()
        local buttonx = 475 
    local buttony = 65
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    drawCornerBox(230, 10, 500, 30)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("AURA DETECTION", 400, 10)
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    drawCornerBox(buttonx,buttony,40,40)
    doauradetectionbuttonhitbox = {
    x = buttonx,
    y = buttony,
    w = 40,
    h = 40
    }

    love.graphics.setColor(1,1,1,1)
        if doauradetection == true then
        
    love.graphics.print("X",buttonx + 12 ,buttony + 5 )
        
    end
    love.graphics.print("Detect auras?",buttonx- 50 , buttony - 25)
end
