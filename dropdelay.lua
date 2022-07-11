local PUGIN = PLUGIN

PLUGIN.name = "Item Pickup & Drop Delay"
PLUGIN.description = "Adds delays between dropping / taking items again."
PLUGIN.author = "Riggs.mackay"

ix.config.Add("dropDelay", 1, "The Delay of dropping items in seconds.", nil, {
    category = PLUGIN.name,
    data = {
        decimals = 1,
        min = 0,
        max = 10,
    },
})

ix.config.Add("takeDelay", 1, "The Delay of taking items in seconds.", nil, {
    category = PLUGIN.name,
    data = {
        decimals = 1,
        min = 0,
        max = 10,
    },
})

if ( SERVER ) then
    function PLUGIN:PlayerInteractItem(ply, action, item)
        if ( action == "drop" ) then
            ply.dropDelay = true
            
            timer.Create("ixDropDelay."..ply:SteamID64(), ix.config.Get("dropDelay", 1), 1, function()
                if ( IsValid(ply) ) then
                    ply.dropDelay = nil
                end
            end)
        elseif ( action == "take" ) then
            ply.takeDelay = true

            timer.Create("ixTakeDelay."..ply:SteamID64(), ix.config.Get("takeDelay", 1), 1, function()
                if ( IsValid(ply) ) then
                    ply.takeDelay = nil
                end
            end)
        end
    end

    function PLUGIN:CanPlayerDropItem(ply)
        if ( ply.dropDelay ) then
            ply:Notify("You need to wait before dropping something again!")
            return false
        end
    end

    function PLUGIN:CanPlayerTakeItem(ply)
        if ( ply.takeDelay ) then
            ply:Notify("You need to wait before picking something up again!")
            return false
        end
    end
end