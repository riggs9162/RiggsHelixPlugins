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

function ENT:Use(client)
    if not ( PLUGIN.allowedFactions[client:GetCharacter():GetFaction()] ) then
        client:Notify("You do not have access to this terminal!")
        return
    end

    if not ( PLUGIN.allowedClasses[client:GetCharacter():GetClass()] ) then
        client:Notify("You do not have access to this terminal!")
        return
    end

    client:SetAction("Logging in. .. ", 1)
    client:DoStaredAction(self, function()
        self:SetNetVar("InUse", true)
        net.Start("ixShopTerminal.Open")
        net.Send(client)
    end, 1, function()
        if ( IsValid(client) ) then
            client:SetAction()
        end
    end)

    self:EmitSound("buttons/button14.wav", 100, 50)
    client:SelectWeapon("ix_hands")
end
