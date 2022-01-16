local PLUGIN = PLUGIN

PLUGIN.name = "XP System"
PLUGIN.author = "Riggs Mackay"
PLUGIN.description = "Apex Gamemode & Impulse like based XP System made from the ground up."

-- old thing, idk why i made tables for this, i guess for config? Gonna redo it in the future.
PLUGIN.xpSystem = PLUGIN.xpSystem or {}
PLUGIN.xpSystem.Time = 600
PLUGIN.xpSystem.GainAmountUser = 5
PLUGIN.xpSystem.GainAmountDonator = 10

ix.util.Include("sv_plugin.lua")

local PLAYER = FindMetaTable("Player")

function PLAYER:GetXP()
	-- Player's XP might not have loaded so we check PData too
	return self:GetNWInt("ixXP") or ( SERVER and self:GetPData("ixXP", 0) or 0 )
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
