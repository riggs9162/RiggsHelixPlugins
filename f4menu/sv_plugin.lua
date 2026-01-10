local PLUGIN = PLUGIN

function PLUGIN:FactionSwitch(client, oldFaction, newFaction, oldClass, newClass)
    if not ( IsValid(client) and client:Alive() ) then
        return
    end

    local char = client:GetCharacter()
    if not ( char ) then
        return
    end

    if ( oldFaction == newFaction and oldClass == newClass ) then
        client:NotifyLocalized("f4MenuSwitchSameFaction")
        return
    end

    local factionData = ix.faction.indices[newFaction]
    if not ( factionData ) then
        client:NotifyLocalized("f4MenuSwitchInvalidFaction")
        return
    end

    local classData = ix.class.list[newClass]
    if not ( classData ) then
        client:NotifyLocalized("f4MenuSwitchInvalidClass")
        return
    end

    if not ( client:HasWhitelist(newFaction) ) then
        client:NotifyLocalized("f4MenuSwitchNotWhitelistedFaction")
        return
    end

    if ( client.HasClassWhitelist and not client:HasClassWhitelist(newClass) ) then
        client:NotifyLocalized("f4MenuSwitchNotWhitelistedClass")
        return
    end

    char:SetFaction(newFaction)
    char:SetClass(class)
    client:Spawn()
end

-- networking
util.AddNetworkString("ixFactionPanelSwitch")

net.Receive("ixFactionPanelSwitch", function(len, client)
    local oldFaction = client:Team()
    local newFaction = net.ReadUInt(8)
    local oldClass = client:GetCharacter():GetClass()
    local newClass = net.ReadUInt(8)

    PLUGIN:FactionSwitch(client, oldFaction, newFaction, oldClass, newClass)
end)
