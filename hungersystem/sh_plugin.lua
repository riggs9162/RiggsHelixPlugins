local PLUGIN = PLUGIN

PLUGIN.name = "Hunger System"
PLUGIN.description = "Adds a Hunger System, simliar to the Apex Gamemode."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

ix.config.Add("hungerTime", 120, "How many seconds between each time a player's needs are calculated", nil, {
    data = {min = 1, max = 600},
    category = "Hunger System"
})

ix.char.RegisterVar("hunger", {
    field = "hunger",
    fieldType = ix.type.number,
    default = 0,
    isLocal = true,
    bNoDisplay = true
})

ix.util.Include("sv_hooks.lua")

ix.command.Add("CharSetHunger", {
    description = "Set character's hunger",
    arguments = {ix.type.character, bit.bor(ix.type.number, ix.type.optional)},
    adminOnly = true,
    OnRun = function(self, ply, char, level)
        char:SetHunger(level or 0)
        ply:Notify(char:GetName() .. "'s hunger was set to " .. ( level or 0 ))
    end
})

ix.command.Add("PlySetHunger", {
    description = "Set player's hunger",
    arguments = {ix.type.player, bit.bor(ix.type.number, ix.type.optional)},
    adminOnly = true,
    OnRun = function(self, ply, target, level)
        local char = target:GetCharacter()
        char:SetHunger(level or 0)
        ply:Notify(target:SteamName() .. "'s hunger was set to " .. ( level or 0 ))
    end
})