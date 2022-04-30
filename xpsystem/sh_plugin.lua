local PLUGIN = PLUGIN

PLUGIN.name = "XP System"
PLUGIN.description = "Apex Gamemode & Impulse like based XP System made from the ground up."
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2022 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

-- old thing, idk why i made tables for this, i guess for config? Gonna redo it in the future.
PLUGIN.xpSystem = PLUGIN.xpSystem or {}
PLUGIN.xpSystem.Time = 600
PLUGIN.xpSystem.GainAmountUser = 5
PLUGIN.xpSystem.GainAmountDonator = 10

ix.util.Include("sv_plugin.lua")

local PLAYER = FindMetaTable("Player")

function PLAYER:GetXP()
    -- Player's XP might not have loaded so we check PData too
    return self:GetLocalVar("ixXP", 0)
end

do
    local cmd = {}

    cmd.description = "Set a player's experience points"
    cmd.arguments = {ix.type.player, ix.type.number}
    cmd.argumentNames = {"Player", "XP"}
    cmd.superAdminOnly = true

    function cmd:OnRun(ply, target, xp)
        if ( xp < 0 ) then
            ply:Notify("You cannot set someone's XP lower than 0!")
            return
        end
        target:SetXP(xp)
        target:Notify(target:Nick() .. "'s XP was set to " .. xp)
    end

    ix.command.Add("SetXP", cmd)
end

do
    local cmd = {}

    cmd.description = "Get a player's experience points"
    cmd.arguments = {ix.type.player}
    cmd.argumentNames = {"Player"}
    cmd.superAdminOnly = true

    function cmd:OnRun(ply, target)
        ply:ChatNotify(target:Nick() .. " has an xp count of " .. target:GetXP())
    end

    ix.command.Add("GetXP", cmd)
end
