local PLUGIN = PLUGIN

PLUGIN.name = "Relations"
PLUGIN.description = "Handles NPC relations based on factions."
PLUGIN.author = "Riggs"
PLUGIN.schema = "HL2 RP"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

ix.config.Add("npcRelations", true, "Whether or not to enable NPC relations.", nil, {
    category = PLUGIN.name
})

ix.config.Add("npcRelationsPriority", 0, "The priority of NPC relationships, which determines how strong the relationship is. Higher values mean stronger relationships.", nil, {
    data = {
        min = 0,
        max = 100,
        decimals = 0
    },
    category = PLUGIN.name
})

if ( CLIENT ) then
    return
end

local combine = {
    ["npc_clawscanner"] = true,
    ["npc_combine_s"] = true,
    ["npc_combinedropship"] = true,
    ["npc_combinegunship"] = true,
    ["npc_helicopter"] = true,
    ["npc_hunter"] = true,
    ["npc_manhack"] = true,
    ["npc_metropolice"] = true,
    ["npc_rollermine"] = true,
    ["npc_stalker"] = true,
    ["npc_strider"] = true,
    ["npc_turret_ceiling"] = true,
    ["npc_turret_floor"] = true,
}

local humans = {
    ["npc_citizen"] = true,
    ["npc_vortigaunt"] = true,
}

local antlions = {
    ["npc_antlion"] = true,
    ["npc_antlion_grub"] = true,
    ["npc_antlion_worker"] = true,
    ["npc_antlionguard"] = true,
    ["npc_antlionguardian"] = true,
}

local zombies = {
    ["npc_fastzombie"] = true,
    ["npc_fastzombie_torso"] = true,
    ["npc_headcrab"] = true,
    ["npc_headcrab_fast"] = true,
    ["npc_poisonzombie"] = true,
    ["npc_zombie"] = true,
    ["npc_zombie_torso"] = true,
    ["npc_zombine"] = true,
}

PLUGIN.relations = {}

PLUGIN.relations[FACTION_CITIZEN] = {
    [D_HT] = antlions,
    [D_HT] = zombies,
    [D_LI] = humans,
    [D_NU] = combine,
}

PLUGIN.relations[FACTION_MPF] = {
    [D_HT] = antlions,
    [D_HT] = zombies,
    [D_LI] = combine,
    [D_NU] = humans,
}
PLUGIN.relations[FACTION_OTA] = PLUGIN.relations[FACTION_MPF]
PLUGIN.relations[FACTION_ADMIN] = PLUGIN.relations[FACTION_MPF]

ix.util.Include("meta/sv_player.lua")
ix.util.Include("sv_hooks.lua")