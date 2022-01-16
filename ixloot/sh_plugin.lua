local PLUGIN = PLUGIN

PLUGIN.name = "Lootable Containers"
PLUGIN.author = "Riggs Mackay"
PLUGIN.description = "Allows you to loot certin crates to obtain loot items."

-- doubled the items in the table so that they are more common than anything else. If you get what I mean.
PLUGIN.randomLoot = {}
PLUGIN.randomLoot.common = {
	"metalplate",
	"metalplate",
	"metalplate",
	"cloth",
	"cloth",
	"cloth",
	"wood",
	"wood",
	"plastic",
	"glue",
	"pipe",
	"gear",
	"water",
	"gunpowder",
}

PLUGIN.randomLoot.rare = {
	"bulletcasing",
	"bulletcasing",
	"refinedmetal",
	"refinedmetal",
	"splint",
	"splint",
	"pistolammo",
	"pistolammo",
	"bandage",
	"electronics",
	"ration",
	"gnome",
}

ix.util.Include("sv_plugin.lua")

if ( CLIENT ) then
	function PLUGIN:PopulateEntityInfo(ent, tooltip)
		local ply = LocalPlayer()
		local ent = ent:GetClass()

		if ( ply:IsCombine() or ply:IsDispatch() ) then
			return false
		end

		if not ( ent:find("ix_loot") ) then
			return false
		end

		local title = tooltip:AddRow("loot")
		title:SetText("Lootable Container")
		title:SetImportant()
		title:SizeToContents()
	end
end
