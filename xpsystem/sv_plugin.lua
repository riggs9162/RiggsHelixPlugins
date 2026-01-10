local PLUGIN = PLUGIN

function PLUGIN:PlayerInitialSpawn(client)
    timer.Create("ix.xpTimer."..client:SteamID64(), PLUGIN.xpSystem.Time, 0, function() PLUGIN:XPGain(client) end)
    client:SetXP(client:GetLocalVar("ixXP") or 0) -- Peeps gonna be sad when they lose all their XP
end

local PLAYER = FindMetaTable("Player")

function PLAYER:SetXP(value)
    if not ( tonumber(value) ) then return end
    
    if ( tonumber(value) < 0 ) then
        return
    end

    self:SetLocalVar("ixXP", tonumber(value))
end

function PLUGIN:XPGain(client)
    if not ( IsValid(client) ) then return end

    if not ( client:IsDonator() or client:IsAdmin() ) then
        client:SetXP(PLUGIN.xpSystem.GainAmountUser + client:GetLocalVar("ixXP", 0))
        client:Notify("For playing on our server for ten minutes, you have gained "..PLUGIN.xpSystem.GainAmountUser.." XP.")
    else
        client:SetXP(PLUGIN.xpSystem.GainAmountDonator + client:GetLocalVar("ixXP", 0))
        client:Notify("For playing on our server for ten minutes, you have gained "..PLUGIN.xpSystem.GainAmountDonator.." XP.")
    end
end

function PLUGIN:PlayerDisconnected(client)
    timer.Remove("ix.xpTimer."..client:SteamID64())
end

concommand.Add("ix_xp_gain", function(client, cmd, args)
    if ( args[1] and client:IsSuperAdmin() ) then
        local target = ix.util.FindPlayer(args[1])
        PLUGIN:XPGain(target)
    end
end)

concommand.Add("ix_xp_set", function(client, cmd, args)
    if ( args[1] and args[2] and client:IsSuperAdmin() ) then
        local target = ix.util.FindPlayer(args[1])
        target:SetLocalVar("ixXP", tonumber(args[2]))
    end
end)

concommand.Add("ix_xp_get", function(client, cmd, args)
    if ( args[1] ) then
        local target = ix.util.FindPlayer(args[1])
        if ( target and target:IsValid() ) then
            client:ChatNotify("==== "..target:SteamName().."'s XP Count ====")
            client:ChatNotify("XP: "..target:GetXP())
        else
            client:ChatNotify("Unspecified User, invalid input.")
        end
    else
        client:ChatNotify("==== YOUR XP Count ====")
        client:ChatNotify("XP: "..client:GetXP())
    end
end)
