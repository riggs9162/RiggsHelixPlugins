local PLUGIN = PLUGIN

PLUGIN.name = "Intro Music"
PLUGIN.description = "Plays music on character load."
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "HL2 RP"
PLUGIN.license = [[
Copyright 2022 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

PLUGIN.introMusic = {
    ["hl1"] = {
        name = "Half-Life 1",
        citizenMusic = {
            "music/hl1_song3.mp3",
        },
        combineMusic = {
            "music/hl1_song19.mp3",
        },
    },
    ["hl2"] = {
        name = "Half-Life 2",
        citizenMusic = {
            "music/hl2_song26_trainstation1.mp3",
        },
        combineMusic = {
            "music/hl2_song19.mp3",
        },
    },
    ["ep1"] = {
        name = "Half-Life 2 Episode 1",
        citizenMusic = {
            "music/vlvx_song1.mp3",
        },
        combineMusic = {
            "music/vlvx_song2.mp3",
        },
    },
    ["ep2"] = {
        name = "Half-Life 2 Episode 2",
        citizenMusic = {
            "music/vlvx_song20.mp3",
        },
        combineMusic = {
            "music/vlvx_song23ambient.mp3",
        },
    },
    ["none"] = {
        name = "None",
        citizenMusic = {
            "",
        },
        combineMusic = {
            "",
        },
    },
}

ix.lang.AddTable("english", {
    optIntroMusic = "Intro Music",
    optdIntroMusic = "What type of music should play once you load in a character?",
})

ix.option.Add("introMusic", ix.type.array, "hl1", {
    category = PLUGIN.name,
    bNetworked = true,
    populate = function()
        local entries = {}

        for k, v in pairs(PLUGIN.introMusic) do
            entries[k] = v.name
        end

        return entries
    end
})

ix.util.Include("sv_plugin.lua")