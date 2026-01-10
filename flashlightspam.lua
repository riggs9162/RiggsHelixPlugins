local PLUGIN = PLUGIN

PLUGIN.name = "Flashlight Anti-Spam"
PLUGIN.description = "Prevents players from spamming the flashlight."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2026 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

ix.config.Add("flashlightSpamDelay", 0.33, "The delay in seconds between flashlight toggles to prevent spam.", nil, {
    data = { min = 0, max = 10, decimals = 2 },
    category = "Performance"
})

if ( SERVER ) then
    function PLUGIN:PlayerSwitchFlashlight(client, state)
        if ( client.ixNextFlashlight and client.ixNextFlashlight > CurTime() ) then
            return false
        end

        client.ixNextFlashlight = CurTime() + ix.config.Get("flashlightSpamDelay", 0.33)
    end
end
