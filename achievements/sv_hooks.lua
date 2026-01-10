local PLUGIN = PLUGIN

function PLUGIN:DoPlayerDeath(client, attacker, dmgInfo)
    if ( IsValid(attacker) and attacker:IsPlayer() and attacker != client ) then
        local charAttacker = attacker:GetCharacter()
        if ( charAttacker ) then
            if ( client:SteamID64() == "76561197963057641" ) then
                ix.achievements:Complete(charAttacker, "riggs")
            elseif ( client:LastHitGroup() == HITGROUP_HEAD ) then
                ix.achievements:Complete(charAttacker, "headshot")
            elseif ( dmgInfo:GetDamage() >= client:GetMaxHealth() ) then
                ix.achievements:Complete(charAttacker, "full health")
            end
        end
    end
end

function PLUGIN:OnPlayerTemperatureDamage(client, temp)
    if ( temp < 36 ) then
        ix.achievements:Complete(client:GetCharacter(), "hypothermia")
    elseif ( temp > 40 ) then
        ix.achievements:Complete(client:GetCharacter(), "hyperthermia")
    end
end

function PLUGIN:OnPlayerCraftedRecipe(client, recipe)
    ix.achievements:Complete(client:GetCharacter(), "first craft")
end
