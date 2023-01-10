local PLUGIN = PLUGIN

PLUGIN.name = "Intro Music"
PLUGIN.description = "Plays music on character load."
PLUGIN.author = "Riggs.mackay"
PLUGIN.schema = "HL2 RP"
PLUGIN.version = "1.0"

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