local licenseText = love.filesystem.read("GNU GENERAL PUBLIC LICENSE.txt")
local licenseScroll = 0

function drawLicenses()
               drawCornerBox(235,75,490,485)
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    drawCornerBox(230, 10, 500, 30)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("LICENSES", 400, 10)

    love.graphics.setScissor(230, 80, 500, 470)
 
    love.graphics.printf(
        licenseText,
        240,
        80 - licenseScroll,
        480
    )


    love.graphics.setScissor()

end

function love.wheelmoved(x, y)
    if currentTab ~= "licenses" then
        return
    end

    licenseScroll = licenseScroll - y * 30

    if licenseScroll < 0 then
        licenseScroll = 0
    end
end