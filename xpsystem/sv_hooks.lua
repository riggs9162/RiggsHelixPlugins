local PLUGIN = PLUGIN

function PLUGIN:PlayerInitialSpawn(client)
    client.ixNextXP = CurTime() + ix.config.Get("xpTime", 600)
end

function PLUGIN:GetXPGainAmount(client)
    return ix.config.Get("xpGainAmountUser", 5)
end

function PLUGIN:PlayerPostThink(client)
    if ( client.ixNextXP and CurTime() >= client.ixNextXP ) then
        client:GainXP()
        client.ixNextXP = CurTime() + ix.config.Get("xpTime", 600)
    end
end
