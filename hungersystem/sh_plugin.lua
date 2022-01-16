local PLUGIN = PLUGIN

PLUGIN.name = "Hunger System"
PLUGIN.author = "Riggs Mackay"
PLUGIN.description = "Adds a Hunger System, simliar to the Apex Gamemode."

ix.config.Add("hungerTime", 120, "How many seconds between each time a player's needs are calculated", nil, {
	data = {min = 1, max = 600},
	category = "Hunger System"
})

ix.char.RegisterVar("hunger", {
	field = "hunger",
	fieldType = ix.type.number,
	default = 0,
	isLocal = true,
	bNoDisplay = true
})

ix.util.Include("sv_hooks.lua")

ix.command.Add("CharSetHunger", {
	description = "Set character's hunger",
	privilege = "Manage Hunger System",
	arguments = {ix.type.character, bit.bor(ix.type.number, ix.type.optional)},
	OnRun = function(self, ply, char, level)
		if not ( ply:IsAdmin() ) then
			ply:Notify("Nice try.")
			return false
		end
		char:SetHunger(level or 0)
		ply:Notify(char:GetName().."'s hunger was set to "..(level or 0))
	end
})

ix.command.Add("SetHunger", {
	description = "Set character's hunger",
	privilege = "Manage Hunger System",
	arguments = {ix.type.character, bit.bor(ix.type.number, ix.type.optional)},
	OnRun = function(self, ply, char, level)
		if not ( ply:IsAdmin() ) then
			return "Nice try."
		end
		char:SetHunger(level or 0)
		ply:Notify(char:GetName().."'s hunger was set to "..(level or 0))
	end
})