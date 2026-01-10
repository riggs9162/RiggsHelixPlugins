local PLUGIN = PLUGIN

function PLUGIN:PlayerSpawn(client)
    if ( client:IsValid() and client:GetCharacter() ) then
        client.ixHungerTick = CurTime() + ( ix.config.Get("hungerTime", 120) )
        client:GetCharacter():SetHunger(100)
    end
end

local factionIgnore = {
    [FACTION_OTA] = true,
}
function PLUGIN:PlayerTick(client)
    if ( client:IsValid() and client:GetCharacter() ) then
        if not client.ixHungerTick or client.ixHungerTick <= CurTime() then
            if ( factionIgnore[client:Team()] ) then return false end
            if ( client:GetMoveType() == MOVETYPE_NOCLIP ) then return false end

            local char = client:GetCharacter()

            if ( char:GetHunger() == 0 ) then
                client:TakeDamage(math.random(10, 20))
                client:EmitSound("npc/barnacle/barnacle_digesting"..math.random(1,2)..".wav", 50)
                client:ChatNotify("You are dying of starvation!")
    
                client.ixHungerTick = CurTime() + 60
                return false
            end

            local newHunger = math.Clamp(char:GetHunger() - 1, 0, 100)
            
            char:SetHunger(newHunger)

            client.ixHungerTick = CurTime() + ( ix.config.Get("hungerTime", 120) )
        end
    end
end
