local PLUGIN = PLUGIN

PLUGIN.name = "Relations"
PLUGIN.description = "Adds a system of relations between factions and NPCs."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

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

if ( FACTION_CP ) then
    PLUGIN.relations[FACTION_CP] = {
        [D_HT] = antlions,
        [D_HT] = zombies,
        [D_LI] = combine,
        [D_NU] = humans,
    }
end

if ( FACTION_TF ) then
    PLUGIN.relations[FACTION_TF] = PLUGIN.relations[FACTION_CP]
end

if ( FACTION_STALKER ) then
    PLUGIN.relations[FACTION_STALKER] = PLUGIN.relations[FACTION_CP]
end

if ( FACTION_CITIZEN ) then
    PLUGIN.relations[FACTION_CITIZEN] = {
        [D_HT] = antlions,
        [D_HT] = zombies,
        [D_LI] = humans,
        [D_NU] = combine,
    }
end

if ( FACTION_VORTIGAUNT ) then
    PLUGIN.relations[FACTION_VORTIGAUNT] = {
        [D_HT] = antlions,
        [D_HT] = zombies,
        [D_LI] = humans,
        [D_NU] = combine,
    }
end

if ( FACTION_ANTLION ) then
    PLUGIN.relations[FACTION_ANTLION] = {
        [D_HT] = combine,
        [D_HT] = humans,
        [D_HT] = zombies,
        [D_LI] = antlions,
    }
end

if ( FACTION_ZOMBIE ) then
    PLUGIN.relations[FACTION_ZOMBIE] = {
        [D_HT] = antlions,
        [D_HT] = combine,
        [D_HT] = humans,
        [D_LI] = zombies,
    }
end

function PLUGIN:OnSetRelationship(ply, ent, relationship)
    if not ( IsValid(ent) and ent:IsNPC() ) then
        return
    end

    local faction = ply:GetCharacter():GetFaction()
    local relations = self.relations[faction]
    if not ( relations ) then
        return
    end

    if ( ply.IsCombine and ply:IsCombine() ) then
        local find = string.find
        local class = ent:GetClass()
        local model = ent:GetModel()

        if ( class == "npc_citizen" and ( find(model, "group02") or find(model, "group03") ) ) then
            ent:AddEntityRelationship(ply, D_HT, 99)
            return
        end

        if ( class == "npc_vortigaunt" and not find(model, "slave") ) then
            ent:AddEntityRelationship(ply, D_HT, 99)
            return
        end
    end
end

ix.util.Include("sv_hooks.lua")
ix.util.Include("sv_plugin.lua")