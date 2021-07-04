local SCANNER_SOUNDS = {
	"npc/scanner/scanner_scan1.wav",
	"npc/scanner/scanner_scan2.wav",
	"npc/scanner/scanner_scan3.wav",
	"npc/scanner/scanner_scan4.wav",
	"npc/scanner/scanner_scan5.wav",

	"npc/scanner/combat_scan1.wav",
	"npc/scanner/combat_scan2.wav",
	"npc/scanner/combat_scan3.wav",
	"npc/scanner/combat_scan4.wav",
	"npc/scanner/combat_scan5.wav",

	"npc/scanner/cbot_servoscared.wav",
	"npc/scanner/cbot_servochatter.wav"
}

function PLUGIN:createScanner(client, isClawScanner)
	if (IsValid(client.ixScn)) then
		return
	end

	local entity = ents.Create("ix_scanner")
	if (not IsValid(entity)) then
		return
	end

	for _, scanner in ipairs(ents.FindByClass("ix_scanner")) do
		if (scanner:GetPilot() == client) then
			scanner:SetPilot(NULL)
		end
	end
	
	entity:SetPos(client:GetPos())
	entity:SetAngles(client:GetAngles())
	entity:SetColor(client:GetColor())
	entity:Spawn()
	entity:Activate()
	entity:setPilot(client)

	if (isClawScanner) then
		entity:setClawScanner()
	end

	-- Draw the player info when looking at the scanner.
	entity:SetNetVar("player", client)
	client.ixScn = entity

	return entity
end

function PLUGIN:PlayerSpawn(client)
	if (IsValid(client.ixScn)) then
		client.ixScn.noRespawn = true
		client.ixScn.spawn = client:GetPos()
		client.ixScn:Remove()
		client.ixScn = nil
		client:SetViewEntity(NULL)
	end
end

concommand.Add("ix_scanner_wipe_photocache", function(client)
	net.Start("ixScannerClearPicture")
	net.Send(client)
end)

function PLUGIN:DoPlayerDeath(client)
	if (IsValid(client.ixScn)) then
		client:AddDeaths(1)
		return false -- Suppress ragdoll creation.
	end
end

function PLUGIN:PlayerDeath(client)
	if (IsValid(client.ixScn) and client.ixScn.health > 0) then
		client.ixScn:die()
		client.ixScn = nil
	end
end

function PLUGIN:KeyPress(client, key)
	if (IsValid(client.ixScn) and (client.ixScnDelay or 0) < CurTime()) then
		local source

		if (key == IN_USE or key == IN_RELOAD) then
			source = table.Random(SCANNER_SOUNDS)
			client.ixScnDelay = CurTime() + 1.5
		elseif (key == IN_WALK) or (key == IN_DUCK) then
			if (client:GetViewEntity() == client.ixScn) then
				client:SetViewEntity(NULL)
			else
				client:SetViewEntity(client.ixScn)
			end
		end

		if (source) then
			client.ixScn:EmitSound(source)
		end
	end
end

function PLUGIN:PlayerNoClip(client)
	if (IsValid(client.ixScn)) then
		return false
	end
end

function PLUGIN:PlayerUse(client, entity)
	if (IsValid(client.ixScn)) then
		return false
	end
end

function PLUGIN:CanPlayerReceiveScan(client, photographer)
	return client.isCombine and client:isCombine()
end

function PLUGIN:PlayerSwitchFlashlight(client, enabled)
	local scanner = client.ixScn
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

function PLUGIN:PlayerCanPickupWeapon(client, weapon)
	if (IsValid(client.ixScn)) then
		return false
	end
end

function PLUGIN:PlayerDropItem(client, item)
	if (IsValid(client.ixScn)) then
		return false
	end
end

function PLUGIN:PlayerEquipItem(client, item)
	if (IsValid(client.ixScn)) then
		return false
	end
end

function PLUGIN:PlayerCanInteractItem(client, item)
	if (IsValid(client.ixScn)) then
		return false
	end
end

function PLUGIN:PlayerCanTakeItem(client, item)
	if (IsValid(client.ixScn)) then
		return false
	end
end

function PLUGIN:PlayerCanUnequipItem(client, item)
	if (IsValid(client.ixScn)) then
		return false
	end
end

function PLUGIN:PlayerFootstep(client)
	if (IsValid(client.ixScn)) then
		return true
	end
end

function PLUGIN:PostPlayerSay(client, chatType, message, anonymous)
	if (IsValid(client.ixScn)) then
		if (chatType == "ic" or chatType == "w" or chatType == "y") then
			return true
		end
	end
end

function PLUGIN:PlayerJoinedClass(client, class)
	if not (class == CLASS_CP_SCANNER) then return end
	if (IsValid(client.ixScn)) then
		client:Spawn()
	end
end