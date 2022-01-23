ITEM.name = "Consumable Base"
ITEM.model = Model("models/props_junk/garbage_takeoutcarton001a.mdl")
ITEM.description = "A base for consumables."
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Consumables"

ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav"
ITEM.useName = "Consume"

ITEM.RestoreHunger = 0

ITEM.functions.Consume = {
	icon = "icon16/user.png",
	name = "Consume",
	OnRun = function(item)
		local ply = item.player
		local character = item.player:GetCharacter()
		local actiontext = "Invalid Action"

		if ( ply.isEatingConsumeable == true ) then
			ply:Notify("You can't stuff too much food in your mouth, bruh.") -- bruh
			return false
		end

		if (item.useSound) then
			if ( string.find(item.useSound, "drink") ) then -- if you have custom sounds for drinking / eating, change this.
				actiontext = "Drinking.."
			else
				actiontext = "Eating.."
			end
		end

		local function EatFunction(ply, character)
			if not ( ply:IsValid() and ply:Alive() and character ) then return end
	
			if ( item.useSound ) then
				if ( istable(item.useSound) ) then
					ply:EmitSound(table.Random(item.useSound))
				else
					ply:EmitSound(item.useSound)
				end
			end
	
			if ( item.RestoreHunger > 0 ) then
				character:SetHunger(math.Clamp(character:GetHunger() + item.RestoreHunger, 0, 100))
			end
		end

		if ( item.useTime ) then
			ply.isEatingConsumeable = true
			ply:SetAction(actiontext, item.useTime, function()
				EatFunction(ply, character)

				ply.isEatingConsumeable = false
			end)
		else
			EatFunction(ply, character)
		end
	end
}
