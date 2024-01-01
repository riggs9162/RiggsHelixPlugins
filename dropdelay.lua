local PUGIN = PLUGIN

PLUGIN.name = "Item Pickup & Drop Delay"
PLUGIN.description = "Adds delays between dropping / taking items again."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

ix.config.Add("dropDelay", 1, "The Delay of dropping items in seconds.", nil, {
    category = PLUGIN.name,
    data = {
        decimals = 1,
        min = 0,
        max = 10,
    },
})

ix.config.Add("takeDelay", 1, "The Delay of taking items in seconds.", nil, {
    category = PLUGIN.name,
    data = {
        decimals = 1,
        min = 0,
        max = 10,
    },
})

if ( SERVER ) then
    function PLUGIN:PlayerInteractItem(ply, action, item)
        if ( action == "drop" ) then
            ply.dropDelay = true
            
            timer.Create("ixDropDelay."..ply:SteamID64(), ix.config.Get("dropDelay", 1), 1, function()
                if ( IsValid(ply) ) then
                    ply.dropDelay = nil
                end
            end)
        elseif ( action == "take" ) then
            ply.takeDelay = true

            timer.Create("ixTakeDelay."..ply:SteamID64(), ix.config.Get("takeDelay", 1), 1, function()
                if ( IsValid(ply) ) then
                    ply.takeDelay = nil
                end
            end)
        end
    end

    function PLUGIN:CanPlayerDropItem(ply)
        if ( ply.dropDelay ) then
            ply:Notify("You need to wait before dropping something again!")
            return false
        end
    end

    function PLUGIN:CanPlayerTakeItem(ply)
        if ( ply.takeDelay ) then
            ply:Notify("You need to wait before picking something up again!")
            return false
        end
    end
end