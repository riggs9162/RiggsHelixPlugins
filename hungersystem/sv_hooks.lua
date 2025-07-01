local PLUGIN = PLUGIN

function PLUGIN:PlayerSpawn(ply)
    if ( ply:IsValid() and ply:GetCharacter() ) then
        ply.ixHungerTick = CurTime() + ( ix.config.Get("hungerTime", 120) )
        ply:GetCharacter():SetHunger(100)
    end
end

PLUGIN.factionIgnore = {
    [FACTION_OTA] = true,
}
function PLUGIN:PlayerTick(ply)
    local char = ply:GetCharacter()

    if ( IsValid(ply) and char ) then
        if not ( ply.ixHungerTick or ply.ixHungerTick <= CurTime() ) then
            if ( self.factionIgnore[ply:Team()] ) then
                return
            end

            if ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then
                return
            end

            if ( char:GetHunger() == 0 ) then
                ply:TakeDamage(math.random(10, 20))
                ply:EmitSound("npc/barnacle/barnacle_digesting"..math.random(1,2)..".wav", 50)
                ply:ChatNotify("You are dying of starvation!")

                ply.ixHungerTick = CurTime() + 60
                return
            end

            local newHunger = math.Clamp(char:GetHunger() - 1, 0, 100)
            char:SetHunger(newHunger)

            ply.ixHungerTick = CurTime() + ix.config.Get("hungerTime", 120)
        end
    end
end
