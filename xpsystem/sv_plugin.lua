local PLUGIN = PLUGIN

function PLUGIN:PlayerInitialSpawn(ply)
    timer.Create("ix.xpTimer."..ply:SteamID64(), PLUGIN.xpSystem.Time, 0, function() PLUGIN:XPGain(ply) end)
    ply:SetXP(ply:GetLocalVar("ixXP") or 0) -- Peeps gonna be sad when they lose all their XP
end

local PLAYER = FindMetaTable("Player")

function PLAYER:SetXP(value)
    if not ( tonumber(value) ) then return end
    
    if ( tonumber(value) < 0 ) then
        return
    end

    self:SetLocalVar("ixXP", tonumber(value))
end

function PLUGIN:XPGain(ply)
    if not ( IsValid(ply) ) then return end

    if not ( ply:IsDonator() or ply:IsAdmin() ) then
        ply:SetXP(PLUGIN.xpSystem.GainAmountUser + ply:GetLocalVar("ixXP", 0))
        ply:Notify("For playing on our server for ten minutes, you have gained "..PLUGIN.xpSystem.GainAmountUser.." XP.")
    else
        ply:SetXP(PLUGIN.xpSystem.GainAmountDonator + ply:GetLocalVar("ixXP", 0))
        ply:Notify("For playing on our server for ten minutes, you have gained "..PLUGIN.xpSystem.GainAmountDonator.." XP.")
    end
end

function PLUGIN:PlayerDisconnected(ply)
    timer.Remove("ix.xpTimer."..ply:SteamID64())
end

concommand.Add("ix_xp_gain", function(ply, cmd, args)
    if ( args[1] and ply:IsSuperAdmin() ) then
        local target = ix.util.FindPlayer(args[1])
        PLUGIN:XPGain(target)
    end
end)

concommand.Add("ix_xp_set", function(ply, cmd, args)
    if ( args[1] and args[2] and ply:IsSuperAdmin() ) then
        local target = ix.util.FindPlayer(args[1])
        target:SetLocalVar("ixXP", tonumber(args[2]))
    end
end)

concommand.Add("ix_xp_get", function(ply, cmd, args)
    if ( args[1] ) then
        local target = ix.util.FindPlayer(args[1])
        if ( target and target:IsValid() ) then
            ply:ChatNotify("==== "..target:SteamName().."'s XP Count ====")
            ply:ChatNotify("XP: "..target:GetXP())
        else
            ply:ChatNotify("Unspecified User, invalid input.")
        end
    else
        ply:ChatNotify("==== YOUR XP Count ====")
        ply:ChatNotify("XP: "..ply:GetXP())
    end
end)