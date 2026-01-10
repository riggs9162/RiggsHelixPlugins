local PLUGIN = PLUGIN

CLASS.name = "Scanner"
CLASS.faction = FACTION_MPF
CLASS.isDefault = true

function ScannerCreate(client)
    local scanner = ix.plugin.list.scanner

    if (scanner) then
        scanner:createScanner(client)
        client.ScannerActive = true
    else
        client:ChatPrint("The server is missing the 'scanner' plugin.")
    end
end

function CLASS:OnSpawn(client)
    ScannerCreate(client)
end

function CLASS:OnSet(client)
    ScannerCreate(client)
end

function CLASS:OnLeave(client)
    if (IsValid(client.ixScn)) then
        local data = {}
            data.start = client.ixScn:GetPos()
            data.endpos = data.start - Vector(0, 0, 1024)
            data.filter = {client, client.ixScn}
        local position = util.TraceLine(data).HitPos

        client.ixScn.spawn = position
        client.ixScn:Remove()
        client.ScannerActive = false

        timer.Simple(0.1, function() client:Spawn() end)
    end
end

CLASS_SCANNER = CLASS.index
