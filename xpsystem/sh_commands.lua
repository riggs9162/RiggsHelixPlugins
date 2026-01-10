ix.command.Add("AddXP", {
    description = "Add XP to a player.",
    adminOnly = true,
    arguments = {
        ix.type.player,
        ix.type.number
    },
    OnRun = function(self, client, target, amount)
        target:GiveXP(amount)
        client:Notify("Added " .. amount .. " XP to " .. target:Name() .. ".")
    end
})

ix.command.Add("TakeXP", {
    description = "Take XP from a player.",
    adminOnly = true,
    arguments = {
        ix.type.player,
        ix.type.number
    },
    OnRun = function(self, client, target, amount)
        target:TakeXP(amount)
        client:Notify("Took " .. amount .. " XP from " .. target:Name() .. ".")
    end
})

ix.command.Add("SetXP", {
    description = "Set a player's XP to a specific amount.",
    adminOnly = true,
    arguments = {
        ix.type.player,
        ix.type.number
    },
    OnRun = function(self, client, target, amount)
        target:SetXP(amount)
        client:Notify("Set " .. target:Name() .. "'s XP to " .. amount .. ".")
    end
})

ix.command.Add("CheckXP", {
    description = "Check your current XP.",
    arguments = {
        bit.bor(ix.type.optional, ix.type.player)
    },
    OnRun = function(self, client, target)
        target = target or client

        local xp = target:GetXP()
        client:Notify((client == target and "You have " .. xp .. " XP.") or (target:Name() .. " has " .. xp .. " XP."))
    end
})

local function notifyOrPrint(client, message)
    if ( IsValid(client) ) then
        client:Notify(message)
    else
        print(message)
    end
end

concommand.Add("ix_xp_debug", function(client, command, arguments)
    if ( IsValid(client) and !client:IsSuperAdmin() or CLIENT ) then return end

    local target = client
    if ( arguments[1] ) then
        target = ix.util.FindPlayer(arguments[1])
        if ( !IsValid(target) ) then
            notifyOrPrint(client, "Player not found.")
            return
        end
    end

    print("XP Debug for " .. target:Name() .. ":")
    print("Current XP: " .. target:GetXP())
    print("Next XP Gain Time: " .. (target.ixNextXP or "N/A"))
end)

concommand.Add("ix_xp_gain", function(client, command, arguments)
    if ( IsValid(client) and !client:IsSuperAdmin() or CLIENT ) then return end

    if ( !arguments[1] ) then
        notifyOrPrint(client, "Usage: ix_xp_gain <player>")
        return
    end

    local target = ix.util.FindPlayer(arguments[1])
    if ( !IsValid(target) ) then
        notifyOrPrint(client, "Player not found.")
        return
    end

    target:GainXP()
    notifyOrPrint(client, "Forced XP gain for " .. target:Name() .. ".")
end)

concommand.Add("ix_xp_setnext", function(client, command, arguments)
    if ( IsValid(client) and !client:IsSuperAdmin() or CLIENT ) then return end

    if ( !arguments[1] ) then
        notifyOrPrint(client, "Usage: ix_xp_setnext <player>")
        return
    end

    local target = ix.util.FindPlayer(arguments[1])
    if ( !IsValid(target) ) then
        notifyOrPrint(client, "Player not found.")
        return
    end

    target.ixNextXP = CurTime() + ix.config.Get("xpTime", 600)
    notifyOrPrint(client, "Set next XP gain time for " .. target:Name() .. ".")
end)

concommand.Add("ix_xp_getnext", function(client, command, arguments)
    if ( IsValid(client) and !client:IsSuperAdmin() or CLIENT ) then return end

    if ( !arguments[1] ) then
        notifyOrPrint(client, "Usage: ix_xp_getnext <player>")
        return
    end

    local target = ix.util.FindPlayer(arguments[1])
    if ( !IsValid(target) ) then
        notifyOrPrint(client, "Player not found.")
        return
    end

    local nextXPTime = target.ixNextXP or "N/A"
    notifyOrPrint(client, "Next XP gain time for " .. target:Name() .. ": " .. nextXPTime)
end)

concommand.Add("ix_xp_reset", function(client, command, arguments)
    if ( IsValid(client) and !client:IsSuperAdmin() or CLIENT ) then return end

    if ( !arguments[1] ) then
        notifyOrPrint(client, "Usage: ix_xp_reset <player>")
        return
    end

    local target = ix.util.FindPlayer(arguments[1])
    if ( !IsValid(target) ) then
        notifyOrPrint(client, "Player not found.")
        return
    end

    target:SetXP(0)
    notifyOrPrint(client, "Reset XP for " .. target:Name() .. ".")
end)

concommand.Add("ix_xp_set", function(client, command, arguments)
    if ( IsValid(client) and !client:IsSuperAdmin() or CLIENT ) then return end

    if ( #arguments < 2 ) then
        notifyOrPrint(client, "Usage: ix_xp_set <player> <amount>")
        return
    end

    local target = ix.util.FindPlayer(arguments[1])
    if ( !IsValid(target) ) then
        notifyOrPrint(client, "Player not found.")
        return
    end

    local amount = tonumber(arguments[2])
    if ( !amount or amount < 0 ) then
        notifyOrPrint(client, "Invalid amount.")
        return
    end

    target:SetXP(amount)
    notifyOrPrint(client, "Set XP for " .. target:Name() .. " to " .. amount .. ".")
end)

concommand.Add("ix_xp_add", function(client, command, arguments)
    if ( IsValid(client) and !client:IsSuperAdmin() or CLIENT ) then return end

    if ( #arguments < 2 ) then
        notifyOrPrint(client, "Usage: ix_xp_add <player> <amount>")
        return
    end

    local target = ix.util.FindPlayer(arguments[1])
    if ( !IsValid(target) ) then
        notifyOrPrint(client, "Player not found.")
        return
    end

    local amount = tonumber(arguments[2])
    if ( !amount or amount <= 0 ) then
        notifyOrPrint(client, "Invalid amount.")
        return
    end

    target:AddXP(amount)
    notifyOrPrint(client, "Added " .. amount .. " XP to " .. target:Name() .. ".")
end)

concommand.Add("ix_xp_take", function(client, command, arguments)
    if ( IsValid(client) and !client:IsSuperAdmin() or CLIENT ) then return end

    if ( #arguments < 2 ) then
        notifyOrPrint(client, "Usage: ix_xp_take <player> <amount>")
        return
    end

    local target = ix.util.FindPlayer(arguments[1])
    if ( !IsValid(target) ) then
        notifyOrPrint(client, "Player not found.")
        return
    end

    local amount = tonumber(arguments[2])
    if ( !amount or amount <= 0 ) then
        notifyOrPrint(client, "Invalid amount.")
        return
    end

    target:TakeXP(amount)
    notifyOrPrint(client, "Took " .. amount .. " XP from " .. target:Name() .. ".")
end)
