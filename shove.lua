local PLUGIN = PLUGIN

PLUGIN.name = "Overwatch Shove"
PLUGIN.description = "A Command which gives the Overwatch the ability to knock players out with the /shove command."
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "HL2 RP"
PLUGIN.license = [[
Copyright 2022 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

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