local PLUGIN = PLUGIN

PLUGIN.name = "Achievements"
PLUGIN.description = "Adds achievements for characters to unlock."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
PLUGIN.readme = [[
Adds achievements for characters to unlock.

To add an achievement, create a new file in the 'achievements' folder in the plugin's 'libs' directory.

Please keep in mind that this plugin requires you to have a basic understanding of Lua to use it, or experienced with programming in general.
]]

ix.achievements = ix.achievements or {}

ix.util.IncludeDir(PLUGIN.folder .. "/achievements", true)

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")