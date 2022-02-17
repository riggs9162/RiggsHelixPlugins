CLASS.name = "Scanner"
CLASS.faction = FACTION_MPF
CLASS.isDefault = true

function ScannerCreate(ply)
    local scanner = ix.plugin.list.scanner

    if (scanner) then
        scanner:createScanner(ply)
        ply.ScannerActive = true
    else
        ply:ChatPrint("The server is missing the 'scanner' plugin.")
    end
end

function CLASS:OnSpawn(ply)
    ScannerCreate(ply)
end

function CLASS:OnSet(ply)
    ScannerCreate(ply)
end

function CLASS:OnLeave(ply)
    if (IsValid(ply.ixScn)) then
        local data = {}
            data.start = ply.ixScn:GetPos()
            data.endpos = data.start - Vector(0, 0, 1024)
            data.filter = {ply, ply.ixScn}
        local position = util.TraceLine(data).HitPos

        ply.ixScn.spawn = position
        ply.ixScn:Remove()
        ply.ScannerActive = false

        timer.Simple(0.1, function() ply:Spawn() end)
    end
end

CLASS_SCANNER = CLASS.index