local PLUGIN = PLUGIN

PLUGIN.name = "Dynamic Flashlight"
PLUGIN.author = "Riggs"
PLUGIN.description = "..."

if CLIENT then

function PLUGIN:PostDrawOpaqueRenderables()
	local client = LocalPlayer()
	if not client:GetNWBool("ixFlashlight") then return end
	
	local flashlight = DynamicLight( client:EntIndex() )
	if (flashlight) then
		flashlight.pos = client:GetShootPos()
		flashlight.r = 255
		flashlight.g = 255
		flashlight.b = 255
		flashlight.brightness = 2
		flashlight.Decay = 1000
		flashlight.Size = 256
		flashlight.DieTime = CurTime() + 1
	end
end

end

if SERVER then

function PLUGIN:Initialize(ply)
	ply:SetNWBool("ixFlashlight", false)
end

function PLUGIN:PlayerSpawn(ply)
	ply:SetNWBool("ixFlashlight", false)
end

function PLUGIN:CharacterLoaded(character)
	local ply = character:GetPlayer()
	ply:SetNWBool("ixFlashlight", false)
end

function PLUGIN:PlayerSwitchFlashlight(ply, enabled)
	ply:SetNWBool("ixFlashlight", !ply:GetNWBool("ixFlashlight", false))
	if ply:GetNWBool("ixFlashlight", true) == true then
		ply:EmitSound("buttons/button24.wav", 60, 100)
	else
		ply:EmitSound("buttons/button10.wav", 60, 70)
	end
	return false
end

end
