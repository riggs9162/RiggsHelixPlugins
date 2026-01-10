local PLUGIN = PLUGIN

PLUGIN.name = "Rappel"
PLUGIN.description = "Allows you to rappel down ledges."
PLUGIN.author = "Riggs"
PLUGIN.schema = "HL2 RP"
PLUGIN.license = [[
Copyright 2026 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

-- use this plugin at your own risk, dont recommend it but ehh...

if ( SERVER ) then
    function PLUGIN:BeginRappel(client, char)
        local movetype = client:GetMoveType()
        local pos = client:GetPos() + (client:GetForward() * 30)
        local trace = {}
        trace.start = pos
        trace.endpos = pos - Vector(0, 0, 1000)
        trace.filter = {client}
        local traceLine = util.TraceLine(trace)
        if ( traceLine.HitPos.z <= client:GetPos().z ) then
            local ent = ents.Create("npc_metropolice")
            if ( client:Team() == FACTION_OTA ) then
                ent = ents.Create("npc_combine_s")
            end

            ent:SetModel(client:GetModel())
            ent:SetSkin(client:GetSkin())
            ent:SetBodyGroups(client:GetBodyGroups())

            ent:SetKeyValue("waitingtorappel", 1)
            ent:SetPos(pos)
            ent:SetAngles(Angle(0, client:EyeAngles().yaw, 0))

            ent:Spawn()
            ent:CapabilitiesClear()
            ent:CapabilitiesAdd(CAP_MOVE_GROUND)

            timer.Create("ixRappelCheck", 0.1, 0, function()
                if ent:IsOnGround() then
                    client:SetPos(ent:GetPos())
                    client:SetEyeAngles(Angle(0, ent:GetAngles().yaw, 0))

                    ent:EmitSound("npc/combine_soldier/zipline_hitground" .. math.random(1,2) .. ".wav", 80)
                    ent:Remove()

                    timer.Destroy("ixRappelCheck")

                    client:Freeze(false)
                    client:SetNoDraw(false)
                    client:SetNotSolid(false)
                    client:DrawWorldModel(true)
                    client:DrawShadow(true)
                    client:SetNoTarget(false)
                    client:GodDisable()

                    client:SetLocalVar("ixRappelingEntity", nil)
                    client:SetLocalVar("ixRappeling", false)
                end
            end)
            ent:AddRelationship("player D_LI")

            ent:EmitSound("npc/combine_soldier/zipline_clip" .. math.random(1,2) .. ".wav", 90)
            timer.Simple(0.5, function()
                if IsValid(ent) then
                    ent:EmitSound("npc/combine_soldier/zipline" .. math.random(1,2) .. ".wav", 90)
                end
            end)

            client:SetLocalVar("ixRappelingEntity", ent)
            client:SetLocalVar("ixRappeling", true)

            client:Freeze(true)
            client:SetNoDraw(true)
            client:SetNotSolid(true)
            client:DrawWorldModel(false)
            client:DrawShadow(false)
            client:GodEnable()
            client:SetNoTarget(true)

            ent:Fire("beginrappel")
            ent:Fire("addoutput", "OnRappelTouchdown rappelent,RunCode,0,-1", 0)
        end
    end
end

ix.command.Add("Rappel", {
    description = "Rappel down a ledge.",
    OnRun = function(self, client)
        if not ( client:IsCombine() ) then
            client:Notify("You are unable to use this!")
            return false
        end

        if not ( client:OnGround() ) then
            client:Notify("You can't rappel whilst falling.")
            return false
        end

        if ( SERVER ) and PLUGIN.BeginRappel then
            PLUGIN:BeginRappel(client)
        end
    end
})

if (CLIENT) then
    function PLUGIN:CalcView(client, pos, angles, fov)
        if ( client:GetLocalVar("ixRappelingEntity") and IsValid( client:GetLocalVar("ixRappelingEntity") ) ) then
            local ent =  client:GetLocalVar("ixRappelingEntity")
            local view = {}
            view.origin = ent:EyePos() - (angles:Forward() * 50)
            view.angles = angles
            view.fov = fov
            view.drawviewer = true

            return view
        end
    end
end
