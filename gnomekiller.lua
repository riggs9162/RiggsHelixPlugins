local PLUGIN = PLUGIN

PLUGIN.name = "Gnome Killer"
PLUGIN.description = "Allows you to kill gnome props, and make a high pitched scream."
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2022 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

local gnomeClasses = {
    ["prop_physics"] = true,
    ["ix_item"] = true,
}
function PLUGIN:EntityTakeDamage(ent)
    if ( gnomeClasses[ent:GetClass()] ) then
        if ( ent:GetModel():find("gnome") ) then
            ent:EmitSound("vo/npc/male01/pain0"..math.random(1,9)..".wav", 75, 150)
            ent:Remove()
        end
    end
end