privateServerLink = ""

local presetpos = 120
local spacing = 60
function drawBiome()
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    drawCornerBox(230, 10, 500, 30)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("BIOME DETECTION", 400, 10)
        if privateServerLink == "" then
                love.graphics.print("Enter a Private Server link here...", 235,55)
        end
    drawCornerBox(230,50,500,40)
    love.graphics.setScissor(230, 50, 490, 40)
    love.graphics.setColor(1,1,1,1)


        love.graphics.print(privateServerLink, 235, 55)
        love.graphics.setScissor()

    love.graphics.setColor(1,1,1,1)
normalBiomeHitbox = drawCheckbox(
    250,
    120,
    "Normal",
    donormalbiomedetection
)

windyBiomeHitbox = drawCheckbox(
    250,
    presetpos + spacing,
    "Windy",
    dowindybiomedetection
)

snowyBiomeHitbox = drawCheckbox(
    250,
    presetpos + spacing * 2,
    "Snowy",
    dosnowybiomedetection
)

rainyBiomeHitbox = drawCheckbox(
    420,
    presetpos,
    "Rainy",
    dorainybiomedetection
)

sandstormBiomeHitbox = drawCheckbox(
    420,
    presetpos + spacing,
    "Sandstorm",
    dosandstormbiomedetection
)

hellBiomeHitbox = drawCheckbox(
    420,
    presetpos + spacing * 2,
    "Hell",
    dohellbiomedetection
)

starfallBiomeHitbox = drawCheckbox(
    590,
    presetpos,
    "Starfall",
    dostarfallbiomedetection
)

heavenBiomeHitbox = drawCheckbox(
    590,
    presetpos + spacing,
    "Heaven",
    doheavenbiomedetection
)

corruptionBiomeHitbox = drawCheckbox(
    590,
    presetpos + spacing * 2,
    "Corruption",
    docorruptionbiomedetection
)

nullBiomeHitbox = drawCheckbox(
    760,
    presetpos,
    "Null",
    donullbiomedetection
)

singularityBiomeHitbox = drawCheckbox(
    760,
    presetpos + spacing,
    "Singularity",
    dosingularitybiomedetection
)

blazingSunBiomeHitbox = drawCheckbox(
    760,
    presetpos + spacing * 2,
    "Blazing Sun",
    doblazingsunbiomedetection
)
end

