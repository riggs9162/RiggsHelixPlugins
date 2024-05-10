local PLUGIN = PLUGIN

PLUGIN.name = "Real Time Lighting"
PLUGIN.description = "Implements a simple real time lighting system which supports Simple Weather and StormFox2." // this has only been tested with simple weather, simple weather is giga chad. Also only supports maps with env_sun entities.
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

// r_farz needs to be 100000 if there is black skies sometimes. command requires sv_cheats sadly.
RunConsoleCommand("r_flashlightdepthres", "8192")

ix.option.Add("realTimeLightingEnabled", ix.type.bool, true, {
    category = "Real Time Lighting",
    default = true,
})

ix.util.Include("cl_plugin.lua")