local PLUGIN = PLUGIN

function PLUGIN:FactionSwitch(client, oldFaction, newFaction, oldClass, newClass)
    if ( !IsValid(client) or !client:Alive() ) then return end

    local character = client:GetCharacter()
    if ( !character ) then return end

    if ( oldFaction == newFaction and oldClass == newClass ) then
        client:NotifyLocalized("f4MenuSwitchSameFaction")
        return
    end

    local factionData = ix.faction.indices[newFaction]
    if ( !factionData ) then
        client:NotifyLocalized("f4MenuSwitchInvalidFaction")
        return
    end

    local classData = ix.class.list[newClass]
    if ( !classData ) then
        client:NotifyLocalized("f4MenuSwitchInvalidClass")
        return
    end

    if ( !client:HasWhitelist(newFaction) ) then
        client:NotifyLocalized("f4MenuSwitchNotWhitelistedFaction")
        return
    end

    if ( client.HasClassWhitelist and !client:HasClassWhitelist(newClass) ) then
        client:NotifyLocalized("f4MenuSwitchNotWhitelistedClass")
        return
    end

    character:SetFaction(newFaction)
    character:SetClass(class)
    client:Spawn()
end

util.AddNetworkString("ixFactionPanelSwitch")
net.Receive("ixFactionPanelSwitch", function(len, client)
    local oldFaction = client:Team()
    local newFaction = net.ReadUInt(8)
    local oldClass = client:GetCharacter():GetClass()
    local newClass = net.ReadUInt(8)

    PLUGIN:FactionSwitch(client, oldFaction, newFaction, oldClass, newClass)
end)
