function drawMainControls()
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    drawCornerBox(230, 10, 500, 30)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("MAIN CONTROLS", 400, 10)

    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    drawCornerBox(400, 100, 160, 30)

    love.graphics.setColor(1, 1, 1, 1)

    if macrostarted == false then
        love.graphics.print("Start", 460, 100)
    else
        love.graphics.print("Stop", 460, 100)
    end
end