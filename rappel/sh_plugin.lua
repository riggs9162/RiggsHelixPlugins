local PLUGIN = PLUGIN

-- use this plugin at your own risk, don't really wanna be bothered to fix or remake this..
PLUGIN.name = "Rappel"
PLUGIN.author = "Riggs Mackay"
PLUGIN.description = "Allows Combine to rappel down from ledges."

if ( SERVER ) then
	function PLUGIN:BeginRappel(ply, char)
		local movetype = ply:GetMoveType()
		local pos = ply:GetPos() + (ply:GetForward() * 30)
		local trace = {}
		trace.start = pos
		trace.endpos = pos - Vector(0, 0, 1000)
		trace.filter = {ply}
		local traceLine = util.TraceLine(trace)
		if ( traceLine.HitPos.z <= ply:GetPos().z ) then
			local ent = ents.Create("npc_metropolice")
			if ( ply:Team() == FACTION_OTA ) then
				ent = ents.Create("npc_combine_s")
			else
				ent = ents.Create("npc_metropolice")
			end

			ent:SetModel(ply:GetModel())
			ent:SetSkin(ply:GetSkin())
			ent:SetBodyGroups(ply:GetBodyGroups())

			ent:SetKeyValue("waitingtorappel", 1) 
			ent:SetPos(pos)
			ent:SetAngles(Angle(0, ply:EyeAngles().yaw, 0))

			ent:Spawn()
			ent:CapabilitiesClear()
			ent:CapabilitiesAdd(CAP_MOVE_GROUND)

			timer.Create("ixRappelCheck", 0.1, 0, function()
				if ent:IsOnGround() then
					ply:SetPos(ent:GetPos())
					ply:SetEyeAngles(Angle(0, ent:GetAngles().yaw, 0))
					
					ent:EmitSound("npc/combine_soldier/zipline_hitground"..math.random(1,2)..".wav", 80)
					ent:Remove()

					timer.Destroy("ixRappelCheck")

					ply:Freeze(false)
					ply:SetNoDraw(false)
					ply:SetNotSolid(false)
					ply:DrawWorldModel(true)
					ply:DrawShadow(true)
					ply:SetNoTarget(false)
					ply:GodDisable()

					ply:SetNWEntity("ixRappelingEntity", nil)
					ply:SetNWBool("ixRappeling", false)
				end
			end)
			ent:AddRelationship("player D_LI")

			ent:EmitSound("npc/combine_soldier/zipline_clip"..math.random(1,2)..".wav", 90)
			timer.Simple(0.5, function()
				if IsValid(ent) then
					ent:EmitSound("npc/combine_soldier/zipline"..math.random(1,2)..".wav", 90)
				end
			end)

			ply:SetNWEntity("ixRappelingEntity", ent)
			ply:SetNWBool("ixRappeling", true)
			
			ply:Freeze(true)
			ply:SetNoDraw(true)
			ply:SetNotSolid(true)
			ply:DrawWorldModel(false)
			ply:DrawShadow(false)
			ply:GodEnable()
			ply:SetNoTarget(true)
			
			ent:Fire("beginrappel")
			ent:Fire("addoutput", "OnRappelTouchdown rappelent,RunCode,0,-1", 0)
		end
	end
end

ix.command.Add("Rappel", {
    description = "Rappel down a ledge.",
    OnRun = function(self, ply)
		if (ply:IsCombine()) then
			if ply:OnGround() then
				if ( SERVER ) and PLUGIN.BeginRappel then
					PLUGIN:BeginRappel(ply)
				end
			else
				ply:Notify("You can't rappel whilst falling.")
				return false
			end
		else
			ply:Notify("You are unable to use this!")
			return false
		end
    end
})

if (CLIENT) then
	function PLUGIN:CalcView(ply, pos, angles, fov)
		if ply:GetNWEntity("ixRappelingEntity") and IsValid(ply:GetNWEntity("ixRappelingEntity")) then
			local ent =  ply:GetNWEntity("ixRappelingEntity")
			local view = {}
			view.origin = ent:EyePos() - (angles:Forward() * 50)
			view.angles = angles
			view.fov = fov
			view.drawviewer = true

			return view
		end
	end
end