local PLUGIN = PLUGIN

PLUGIN.name = "User Interface Rework (Tab Menu)"
PLUGIN.description = "Reworks the tab menu to be more user friendly."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

ix.config.Add("tabMenuTitle", false, "Wether or not there should be titles on tabs within the tab menu. (NOTE: THIS CAN BE BUGGY ON PLUGINS THAT ADD CUSTOM TABS)", function()
    if ( SERVER ) then
        for k, v in ipairs(player.GetAll()) do
            v:SendLua([[if not ix.gui.menu then return end ix.gui.menu:Remove() vgui.Create("ixMenu")]])
        end
    end
end, {
    category = "Appearance (User Interface)",
})