local PLUGIN = PLUGIN

function PLUGIN:DoPlayerDeath(ply, attacker, dmgInfo)
    if ( IsValid(attacker) and attacker:IsPlayer() and attacker != ply ) then
        local charAttacker = attacker:GetCharacter()
        if ( charAttacker ) then
            if ( ply:SteamID64() == "76561197963057641" ) then
                ix.achievements:Complete(charAttacker, "riggs")
            elseif ( ply:LastHitGroup() == HITGROUP_HEAD ) then
                ix.achievements:Complete(charAttacker, "headshot")
            elseif ( dmgInfo:GetDamage() >= ply:GetMaxHealth() ) then
                ix.achievements:Complete(charAttacker, "full health")
            end
        end
    end
end

function PLUGIN:OnPlayerTemperatureDamage(ply, temp)
    if ( temp < 36 ) then
        ix.achievements:Complete(ply:GetCharacter(), "hypothermia")
    elseif ( temp > 40 ) then
        ix.achievements:Complete(ply:GetCharacter(), "hyperthermia")
    end
end

function PLUGIN:OnPlayerCraftedRecipe(ply, recipe)
    ix.achievements:Complete(ply:GetCharacter(), "first craft")
end