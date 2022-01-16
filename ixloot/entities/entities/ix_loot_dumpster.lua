local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName		= "Loot Dumpster"
ENT.Author			= "Riggs Mackay"
ENT.Purpose			= "Allows you to take loot from it."
ENT.Instructions	= "Press E"
ENT.Category 		= "IX:HL2RP"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/props_junk/TrashDumpster01a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS) 
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    
        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
            phys:Wake()
            phys:EnableMotion(false)
        end
    end

	function ENT:SpawnFunction(ply, trace)
        local angles = ply:GetAngles()

		local entity = ents.Create("ix_loot_dumpster")
		entity:SetPos(trace.HitPos)
		entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
		entity:Spawn()
		entity:Activate()

		return entity
	end
    
    function ENT:OnTakeDamage()
        return false
    end
    
    function ENT:AcceptInput(Name, Activator, Caller)
        if (Name == "Use" and Caller:IsPlayer()) then
            PLUGIN:SearchLootContainer(self, Caller)
        end
    end
end