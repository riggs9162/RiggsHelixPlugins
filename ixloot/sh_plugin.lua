local PLUGIN = PLUGIN

PLUGIN.name = "Lootable Containers"
PLUGIN.description = "Allows you to loot certin crates to obtain loot items."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

-- doubled the items in the table so that they are more common than anything else. If you get what I mean.
PLUGIN.randomLoot = {}
PLUGIN.randomLoot.common = {
    "metalplate",
    "metalplate",
    "metalplate",
    "cloth",
    "cloth",
    "cloth",
    "wood",
    "wood",
    "plastic",
    "glue",
    "pipe",
    "gear",
    "water",
    "gunpowder",
}

PLUGIN.randomLoot.rare = {
    "bulletcasing",
    "bulletcasing",
    "refinedmetal",
    "refinedmetal",
    "splint",
    "splint",
    "pistolammo",
    "pistolammo",
    "bandage",
    "electronics",
    "ration",
    "gnome",
}

ix.util.Include("sv_plugin.lua")

if ( CLIENT ) then
    function PLUGIN:PopulateEntityInfo(ent, tooltip)
        local ply = LocalPlayer()
        local ent = ent:GetClass()

        if ( ply:IsCombine() or ply:IsDispatch() ) then
            return false
        end

        if not ( ent:find("ix_loot") ) then
            return false
        end

        local title = tooltip:AddRow("loot")
        title:SetText("Lootable Container")
        title:SetImportant()
        title:SizeToContents()
    end
end
