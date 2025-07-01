local PLUGIN = PLUGIN

PLUGIN.name = "Hand Pickup Blocker"
PLUGIN.author = "Riggs"
PLUGIN.description = "Prevents listed items from being grabbed with the ix_hands SWEP."

PLUGIN.blacklist = {
    -- ["water_bottle"] = true,
    -- ["empty_mug"] = true,
    -- ["spas12"] = true,
}

ix.config.Add("handPickupBlacklist", true, "Enable Hand Pickup Blacklist", nil, {
    category = PLUGIN.name
})

ix.config.Add("handPickupBlacklistMessageShow", true, "Show message when trying to pick up blacklisted items", nil, {
    category = PLUGIN.name
})

ix.config.Add("handPickupBlacklistMessage", "You can't pick that up with your hands.", "Message shown when trying to pick up blacklisted items", nil, {
    category = PLUGIN.name
})

function PLUGIN:CanPlayerHoldObject(client, entity)
    if ( !ix.config.Get("handPickupBlacklist", true) ) then return end
    if ( !entity or !entity.GetItemTable ) then return end

    local item = entity:GetItemTable()
    if ( !item ) then return end

    if ( self.blacklist[item.uniqueID] ) then
        if ( ix.config.Get("handPickupBlacklistMessageShow", true) ) then
            client:NotifyLocalized(ix.config.Get("handPickupBlacklistMessage", "You can't pick that up with your hands."))
        end

        return false
    end
end