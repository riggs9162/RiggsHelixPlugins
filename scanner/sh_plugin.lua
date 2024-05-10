local PLUGIN = PLUGIN

PLUGIN.name = "Scanners"
PLUGIN.description = "Adds a playable scanner that can take pictures."
PLUGIN.author = "Chessnut, Riggs"
PLUGIN.schema = "HL2 RP"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

if ( CLIENT ) then
    PLUGIN.PICTURE_WIDTH = 580
    PLUGIN.PICTURE_HEIGHT = 420
end

ix.util.Include("sv_photos.lua")
ix.util.Include("cl_photos.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")

ix.command.Add("PhotoChache", {
    description = "Opens the scanner photo cache.",
    OnRun = function(self, ply)
        if !(ply:IsCombine() or IsValid(ply.ixScn)) then
            return "Only Combine Players can view the scanner photo cache!"
        end
        
        ply:ConCommand("ix_scanner_photocache")
    end
})
