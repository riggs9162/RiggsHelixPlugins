local PLUGIN = PLUGIN

function PLUGIN:FactionSwitch(ply, oldFaction, newFaction, oldClass, newClass)
    if not ( IsValid(ply) and ply:Alive() ) then
        return
    end

    local char = ply:GetCharacter()
    if not ( char ) then
        return
    end

    if ( oldFaction == newFaction and oldClass == newClass ) then
        ply:NotifyLocalized("f4MenuSwitchSameFaction")
        return
    end

    local factionData = ix.faction.indices[newFaction]
    if not ( factionData ) then
        ply:NotifyLocalized("f4MenuSwitchInvalidFaction")
        return
    end

    local classData = ix.class.list[newClass]
    if not ( classData ) then
        ply:NotifyLocalized("f4MenuSwitchInvalidClass")
        return
    end

    if not ( ply:HasWhitelist(newFaction) ) then
        ply:NotifyLocalized("f4MenuSwitchNotWhitelistedFaction")
        return
    end

    if ( ply.HasClassWhitelist and not ply:HasClassWhitelist(newClass) ) then
        ply:NotifyLocalized("f4MenuSwitchNotWhitelistedClass")
        return
    end

    char:SetFaction(newFaction)
    char:SetClass(class)
    ply:Spawn()
end

// networking
util.AddNetworkString("ixFactionPanelSwitch")

net.Receive("ixFactionPanelSwitch", function(len, ply)
    local oldFaction = ply:Team()
    local newFaction = net.ReadUInt(8)
    local oldClass = ply:GetCharacter():GetClass()
    local newClass = net.ReadUInt(8)

    PLUGIN:FactionSwitch(ply, oldFaction, newFaction, oldClass, newClass)
end)