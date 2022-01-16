local PLUGIN = PLUGIN

PLUGIN.name = "Overwatch Shove"
PLUGIN.author = "Riggs Mackay"
PLUGIN.description = "A Command which gives the Overwatch the ability to knock players out with the /shove command."

ix.config.Add("shoveTime", 20, "How long should a character be unconscious after being knocked out?", nil, {
    data = {min = 5, max = 60},
})

ix.command.Add("shove", {
    description = "Knock someone out.",
    OnRun = function(self, ply)
        if not ( ply:Team() == FACTION_OTA ) then
            return false, "You need to be a Overwatch Soldier to run this command."
        end

        local ent = ply:GetEyeTraceNoCursor().Entity
        local target

        if ( ent:IsPlayer() ) then 
            target = ent
        else
            return false, "You must be looking at someone!"     
        end

        if ( target ) and ( target:GetPos():Distance(ply:GetPos()) >= 50 ) then
            return false, "You need to be close to your target!"
        end 

        ply:ForceSequence("melee_gunhit")
        timer.Simple(0.3, function()
            target:SetVelocity(ply:GetAimVector() * 300)
        end)
        timer.Simple(0.4, function()
            ply:EmitSound("physics/body/body_medium_impact_hard6.wav")
            target:SetRagdolled(true, ix.config.Get("shoveTime", 20))
        end)
    end,
})