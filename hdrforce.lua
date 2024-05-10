local PLUGIN = PLUGIN

PLUGIN.name = "HDR Force"
PLUGIN.description = "Forces people to switch to HDR Level 2."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

if ( CLIENT ) then
    // check if the player is pressing anything
    function PLUGIN:KeyPress()
        // but dont run until we are actually playing
        if ( vgui.CursorVisible() ) then
            return
        end

        local hdr = GetConVar("mat_hdr_level")
        if ( hdr:GetInt() != 2 ) then
            if ( IsValid(ix.gui.characterMenu) ) then
                ix.gui.characterMenu:SetVisible(false)
            end
    
            Derma_Query("This server requires you to enable HDR.", "Helix", "Ok!", function()
                RunConsoleCommand("disconnect")
            end)
        end
    end
end