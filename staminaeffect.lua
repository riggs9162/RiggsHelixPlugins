PLUGIN.name = "Stamina Effect"
PLUGIN.author = "Riggs"
PLUGIN.description = "..."

ix.StaminaBreathe = false

function PLUGIN:PlayerTick(ply)
	if not ply.NextStaminaBreathe or ply.NextStaminaBreathe <= CurTime() then
		local stamina = ply:GetNetVar("stm", 100)
		if stamina <= 10 then -- change the '10' to whatever you want for a reasonable number.
			ply:EmitSound("player/heartbeat1.wav", 60)
			ply:EmitSound("player/breathe1.wav", 60)
			ix.StaminaBreathe = true
			timer.Simple(3.9, function()
				ply:StopSound("player/heartbeat1.wav")
				ply:StopSound("player/breathe1.wav")
				ix.StaminaBreathe = false
			end)
			ply.NextStaminaBreathe = CurTime() + 4
		end
	end
end

if CLIENT then
    local staminabluralpha = 0
    local staminabluramount = 0
    local staminablurmaxamount = 5
    
    function PLUGIN:HUDPaint()
            local frametime = RealFrameTime()
            
            if (ix.option.Get("cheapBlur", false)) then
                staminablurmaxamount = 10
            end
            
            if (ix.StaminaBreathe == true) then
                staminabluralpha = Lerp(frametime / 2, staminabluralpha, 255)
                staminabluramount = Lerp(frametime / 2, staminabluramount, staminablurmaxamount)
            else
                staminabluralpha = Lerp(frametime / 2, staminabluralpha, 0)
                staminabluramount = Lerp(frametime / 2, staminabluramount, 0)
            end
            
            ix.util.DrawBlurAt(0, 0, ScrW(), ScrH(), staminabluramount, 0.2, staminabluralpha)
    end
end
