local PLUGIN = PLUGIN

function PLUGIN:PlayerSpawn(ply)
	if ( ply:IsValid() and ply:GetCharacter() ) then
		ply.ixHungerTick = CurTime() + ( ix.config.Get("hungerTime", 120) )
		ply:GetCharacter():SetHunger(100)
	end
end

local factionIgnore = {
	[FACTION_OTA] = true,
}
function PLUGIN:PlayerTick(ply)
	if ( ply:IsValid() and ply:GetCharacter() ) then
		if not ply.ixHungerTick or ply.ixHungerTick <= CurTime() then
			if ( factionIgnore[ply:Team()] ) then return false end
			if ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then return false end

			local char = ply:GetCharacter()

			if ( char:GetHunger() == 0 ) then
				ply:TakeDamage(math.random(10, 20))
				ply:EmitSound("npc/barnacle/barnacle_digesting"..math.random(1,2)..".wav", 50)
				ply:ChatNotify("You are dying of starvation!")
	
				ply.ixHungerTick = CurTime() + 60
				return false
			end

			local newHunger = math.Clamp(char:GetHunger() - 1, 0, 100)
			
			char:SetHunger(newHunger)

			ply.ixHungerTick = CurTime() + ( ix.config.Get("hungerTime", 120) )
		end
	end
end
