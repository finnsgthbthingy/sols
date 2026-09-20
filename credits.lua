    local finn = love.graphics.newImage("assets/images/finn.png")

function drawCredits()
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    drawCornerBox(230, 10, 500, 30)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("CREDITS", 400, 10)

    love.graphics.draw(finn, 200, 50, 0, 0.075, 0.075)

    drawCornerBox(360, 50, 300,155)
    
    love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("finn\n -i make macro and gui\n -i beginner", 365, 50)

end