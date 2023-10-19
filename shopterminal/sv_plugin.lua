local PLUGIN = PLUGIN

util.AddNetworkString("ixShopTerminal.Open")
util.AddNetworkString("ixShopTerminal.Close")
util.AddNetworkString("ixShopTerminal.Checkout")

net.Receive("ixShopTerminal.Close", function(len, ply)
    if not ( IsValid(ply) and IsValid(ply:GetEyeTrace().Entity) and ply:GetEyeTrace().Entity:GetClass() == "ix_shopterminal" ) then
        return
    end
    ply:GetEyeTrace().Entity:SetNetVar("InUse", false)
end)

net.Receive("ixShopTerminal.Checkout", function(len, ply)
    local char = ply:GetCharacter()
    if not ( IsValid(ply) and char and char:GetClass() == PLUGIN.cwuClass or CLASS_CWU ) then
        return
    end

    local indicies = net.ReadUInt(8)
    local items = {}

    for _ = 1, indicies do
        items[net.ReadString()] = net.ReadUInt(8)
    end

    if ( table.IsEmpty(items) ) then
        return
    end

    local cost = 0

    for k, v in pairs(items) do
        local itemTable = ix.item.list[k]

        if (itemTable) then
            local amount = math.Clamp(tonumber(v) or 0, 0, 10)
            items[k] = amount

            if (amount == 0) then
                items[k] = nil
            else
                cost = cost + (amount * (itemTable.price or 0))
            end
        else
            items[k] = nil
        end
    end

    if ( table.IsEmpty(items) ) then
        return
    end

    PrintTable(items)

    if ( char:HasMoney(cost) ) then
        char:TakeMoney(cost)
        ply:Notify(ix.config.Get("shipmentDeliverMessage"))

        // this might be messy and horrid, but meh. in the future i will find a better way..
        local deliverPos = Vector(tonumber(ix.config.Get("shipmentDeliverPositionXValue")), tonumber(ix.config.Get("shipmentDeliverPositionYValue")), tonumber(ix.config.Get("shipmentDeliverPositionZValue")))

        local entity = ents.Create("ix_shopterminal_shipment")
        entity:Spawn()
        entity:SetPos(deliverPos)
        entity:SetItems(items)
        entity:SetNetVar("owner", char:GetID())

        local shipments = char:GetVar("charEnts") or {}
        table.insert(shipments, entity)
        char:SetVar("charEnts", shipments, true)

		hook.Run("CreateShipment", ply, entity)
    else
        ix.util.Notify("You do not have enough "..ix.currency.plural.." to buy your cart!")
    end
end)