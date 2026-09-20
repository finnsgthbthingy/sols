local thread = require("love.thread")
local channel = thread.getChannel("webhookQueue")

local json = require("json")
local ltn12 = require("ltn12")
local http = require("ssl.https")

while true do
    local request = channel:demand()

    local jsonPayload = json.encode({
        embeds = {
            request.embed
        },
        content = request.content
    })

    local responseBody, statusCode = http.request {
        url = request.url,
        method = "POST",

        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#jsonPayload)
        },

        source = ltn12.source.string(jsonPayload)
    }

    if statusCode == 204 then
        print("Webhook sent successfully!")
    else
        print("Webhook failed. Status: " .. tostring(statusCode))
    end
end