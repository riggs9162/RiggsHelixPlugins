local PLUGIN = PLUGIN

local SCANNER_SOUNDS = {
    "npc/scanner/scanner_blip1.wav",
    "npc/scanner/scanner_scan1.wav",
    "npc/scanner/scanner_scan2.wav",
    "npc/scanner/scanner_scan4.wav",
    "npc/scanner/scanner_scan5.wav",
    "npc/scanner/combat_scan1.wav",
    "npc/scanner/combat_scan2.wav",
    "npc/scanner/combat_scan3.wav",
    "npc/scanner/combat_scan4.wav",
    "npc/scanner/combat_scan5.wav",
    "npc/scanner/cbot_servoscared.wav",
    "npc/scanner/cbot_servochatter.wav",
}

function PLUGIN:createScanner(ply, isClawScanner)
    if (IsValid(ply.ixScn)) then
        return
    end

    local entity = ents.Create("ix_scanner")
    if (not IsValid(entity)) then
        return
    end

    for _, scanner in ipairs(ents.FindByClass("ix_scanner")) do
        if (scanner:GetPilot() == ply) then
            scanner:SetPilot(NULL)
        end
    end
    
    entity:SetPos(ply:GetPos())
    entity:SetAngles(ply:GetAngles())
    entity:SetColor(ply:GetColor())
    entity:Spawn()
    entity:Activate()
    entity:setPilot(ply)

    if (isClawScanner) then
        entity:setClawScanner()
    end

    -- Draw the player info when looking at the scanner.
    entity:SetNetVar("player", ply)
    ply.ixScn = entity

    return entity
end

function PLUGIN:PlayerSpawn(ply)
    if (IsValid(ply.ixScn)) then
        ply.ixScn.noRespawn = true
        ply.ixScn.spawn = ply:GetPos()
        ply.ixScn:Remove()
        ply.ixScn = nil
        ply:SetViewEntity(NULL)
    end
end

function PLUGIN:DoPlayerDeath(ply)
    if (IsValid(ply.ixScn)) then
        ply:AddDeaths(1)
        return false -- Suppress ragdoll creation.
    end
end

function PLUGIN:PlayerDeath(ply)
    if (IsValid(ply.ixScn) and ply.ixScn.health > 0) then
        ply.ixScn:die()
        ply.ixScn = nil
    end
end

function PLUGIN:KeyPress(ply, key)
    if (IsValid(ply.ixScn) and (ply.ixScnSoundDelay or 0) < CurTime()) then
        local source

        if (key == IN_USE) then
            source = table.Random(SCANNER_SOUNDS)
            ply.ixScnSoundDelay = CurTime() + 1.75
        elseif (key == IN_RELOAD) then
            source = "npc/scanner/scanner_talk"..math.random(1, 2)..".wav"
            ply.ixScnSoundDelay = CurTime() + 8
        elseif (key == IN_DUCK) then
            if (ply:GetViewEntity() == ply.ixScn) then
                ply:SetViewEntity(NULL)
            else
                ply:SetViewEntity(ply.ixScn)
            end
        end

        if (source) then
            ply.ixScn:EmitSound(source)
        end
    end
end

function PLUGIN:PlayerNoClip(ply)
    if (IsValid(ply.ixScn)) then
        return false
    end
end

function PLUGIN:PlayerUse(ply, entity)
    if (IsValid(ply.ixScn)) then
        return false
    end
end

function PLUGIN:CanPlayerReceiveScan(ply, photographer)
    return ply:IsCombine() or ply:IsDispatch()
end

function PLUGIN:PlayerSwitchFlashlight(ply, enabled)
    local scanner = ply.ixScn
    if (not IsValid(scanner)) then return end

    if ((scanner.nextLightToggle or 0) >= CurTime()) then return false end
    scanner.nextLightToggle = CurTime() + 0.5

    local pitch
    if (scanner:isSpotlightOn()) then
        scanner:disableSpotlight()
        pitch = 240
    else
        scanner:enableSpotlight()
        pitch = 250
    end

    scanner:EmitSound("npc/turret_floor/click1.wav", 50, pitch)
    return false
end

function PLUGIN:PlayerCanPickupWeapon(ply, weapon)
    if (IsValid(ply.ixScn)) then
        return false
    end
end

function PLUGIN:PlayerDropItem(ply, item)
    if (IsValid(ply.ixScn)) then
        return false
    end
end

function PLUGIN:PlayerEquipItem(ply, item)
    if (IsValid(ply.ixScn)) then
        return false
    end
end

function PLUGIN:PlayerCanInteractItem(ply, item)
    if (IsValid(ply.ixScn)) then
        return false
    end
end

function PLUGIN:PlayerCanTakeItem(ply, item)
    if (IsValid(ply.ixScn)) then
        return false
    end
end

function PLUGIN:PlayerCanUnequipItem(ply, item)
    if (IsValid(ply.ixScn)) then
        return false
    end
end

function PLUGIN:PlayerFootstep(ply)
    if (IsValid(ply.ixScn)) then
        return true
    end
end

function PLUGIN:PostPlayerSay(ply, chatType, message, anonymous)
    if (IsValid(ply.ixScn)) then
        if (chatType == "ic" or chatType == "w" or chatType == "y") then
            return true -- Scanners cant talk!
        end
    end
end

function PLUGIN:PlayerJoinedClass(ply, class)
    if not (class == CLASS_SCANNER) then return end
    if (IsValid(ply.ixScn)) then
        ply:Spawn()
    end
end