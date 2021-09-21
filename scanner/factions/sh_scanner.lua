--[[ Base Config ]]--

FACTION.name = "Scanner"
FACTION.description = "Simple Scanner Faction."
FACTION.color = Color(255, 0, 0)

--[[ Additional Config ]]--

FACTION.models = {
	"models/combine_scanner.mdl",
}

FACTION.isGloballyRecognized = true
FACTION.isDefault = false

FACTION.payTime = 600
FACTION.pay = 10

FACTION.weapons = {}

--[[ Custom Config ]]--

FACTION.defaultclass = CLASS_SCANNER

--[[ Custom Functions ]]--

function FACTION:GetDefaultName(ply)
	return "OW.SCN-"..tostring(math.random(10,99)), true
end

function FACTION:OnCharacterCreated(ply, character)
	local inventory = character:GetInventory()

	character:SetClass(self.defaultclass)
	character:SetName(self:GetDefaultName())
	character:SetModel(self.models[1])
end

function FACTION:OnTransferred(character)
	local inventory = character:GetInventory()
	character:SetClass(self.defaultclass)
end

--[[ Do not change! ]]--

FACTION_SCANNER = FACTION.index