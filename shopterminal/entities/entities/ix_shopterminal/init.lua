local PLUGIN = PLUGIN

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_combine/breenconsole.mdl")
    self:PhysicsInit(SOLID_VPHYSICS) 
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
    if not ( PLUGIN.allowedFactions[ply:GetCharacter():GetFaction()] ) then
        ply:Notify("You do not have access to this terminal!")
        return
    end

    if not ( PLUGIN.allowedClasses[ply:GetCharacter():GetClass()] ) then
        ply:Notify("You do not have access to this terminal!")
        return
    end

    ply:SetAction("Logging in...", 1)
    ply:DoStaredAction(self, function()
        self:SetNetVar("InUse", true)
        net.Start("ixShopTerminal.Open")
        net.Send(ply)
    end, 1, function()
        if ( IsValid(ply) ) then
            ply:SetAction()
        end
    end)

    self:EmitSound("buttons/button14.wav", 100, 50)
    ply:SelectWeapon("ix_hands")
end