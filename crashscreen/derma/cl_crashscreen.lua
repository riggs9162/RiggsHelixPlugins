local PANEL = {}

local waits = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:Center()
     self:MoveToFront()
     self:SetAlpha(0)
     self:AlphaTo(255, 1.2)

     local function wait(s, f)
        table.insert(waits, {SysTime() + s, function()
            if IsValid(self) then
                f()
            end
        end})
    end

    wait(3.33, function()
         http.Fetch("http://api.steampowered.com/ISteamApps/GetServersAtAddress/v0001?addr="..game.GetIPAddress(), function(json)
             if not IsValid(self) then
                 return
             end
             
             local data = util.JSONToTable(json)

             if not data["response"]["servers"] or not data["response"]["servers"][0] then
                 self.ServerIsOff = true
                 self:DoLamar()
             else
                 self.ServerIsOff = false
             end
         end, function()
             if not IsValid(self) then
                 return
             end
             
             self.ServerIsOff = false
         end)
     end)
end

function PANEL:DoLamar()
    local function wait(s, f)
        table.insert(waits, {SysTime() + s, function()
            if IsValid(self) then
                f()
            end
        end})
    end

    local function doAnim()
        self.lamar = vgui.Create("ixModelPanel", self)
         self.lamar:Dock(FILL)
         self.lamar:SetFOV(90)
         self.lamar:SetModel("models/lamarr.mdl")
         self.lamar:SetAnimated(true)

         function self.lamar:LayoutEntity(ent)
             ent:FrameAdvance()
             return
         end

         local badcarb = self.lamar:GetEntity():LookupSequence("lamarr_crow")

         self.lamar:GetEntity():ResetSequence(badcarb)

         local pos = Vector(120, 50, 50)
         self.lamar:SetCamPos(pos)
         self.lamar:SetLookAt(pos + Vector(-10, -70, -10))
    end

    local function doPostText()
        self.backsoon = vgui.Create("DLabel", self)
        self.backsoon:SetText("We'll be back soon!")
        self.backsoon:SetFont("ixTitleFont")
        self.backsoon:SizeToContents()
        self.backsoon:Center()
        self.backsoon:SetAlpha(0)
        self.backsoon:AlphaTo(200, 8)

        timer.Simple(8, function()
            if IsValid(self) then
                self.backsoon:AlphaTo(0, 10)
            end
        end)
    end

    local r = 1
    wait(r, function()
        surface.PlaySound("npc/headcrab/pain1.wav")

        local x = 0
        x = x + 1
        wait(x, function()
            surface.PlaySound("vo/k_lab/kl_comeout.wav")
        end)

        x = x + 2.3
        wait(x, function()
            surface.PlaySound("npc/headcrab/alert1.wav")
        end)

        x = x + 2
        wait(x, function()
            surface.PlaySound("vo/k_lab/kl_lamarr.wav")
        end)

        x = x + 2.6
        wait(x, function()
            surface.PlaySound("npc/headcrab/pain3.wav")
        end)

        x = x + 2
        wait(x, function()
            surface.PlaySound("vo/k_lab/kl_nocareful.wav")
        end)

        x = x + 2.1
        wait(x, doAnim)

        x = x + 1.6
        wait(x, function()
            surface.PlaySound("npc/headcrab/attack2.wav")
        end)

        x = x + 0.6
        wait(x, function()
            surface.PlaySound("vehicles/v8/vehicle_impact_heavy1.wav")
            surface.PlaySound("ambient/energy/zap6.wav")

            timer.Simple(0.3, function()
                surface.PlaySound("ambient/energy/zap7.wav")
            end)
        end)

        wait(x + 2.5, doPostText)

        x = x + 3
        wait(x, function()
            surface.PlaySound("ambient/energy/spark1.wav")
        end)

        x = x + 1.2
        wait(x, function()
            surface.PlaySound("ambient/energy/spark3.wav")
        end)
    end)
end

function PANEL:Think()
    self:MoveToFront()

    for v,k in pairs(waits) do
        if k != nil and k[1] < SysTime() then
            k[2]()

            waits[v] = nil
        end
    end
end

function PANEL:Paint(w, h)
    ix.util.DrawBlur(self, 10)
    draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
end

function PANEL:PaintOver()
    draw.DrawText(":( Connection lost", "ixTitleFont", ScrW() / 2, 10, color_white, TEXT_ALIGN_CENTER)

    if self.ServerIsOff == nil then
        draw.DrawText("Checking server status...", "ixBigFont", ScrW() / 2, 130, color_white, TEXT_ALIGN_CENTER)
        return
    end

    if self.ServerIsOff then
        draw.DrawText("The server has gone offline. Try reconnecting in a few minutes.", "ixBigFont", ScrW() / 2, 130, color_white, TEXT_ALIGN_CENTER)
    else
        draw.DrawText("You've lost connection to the server. Try reconnecting in a few minutes.", "ixBigFont", ScrW() / 2, 130, color_white, TEXT_ALIGN_CENTER)
        draw.DrawText("Check your router or internet connection.", "ixBigFont", ScrW() / 2, h + 160, color_white, TEXT_ALIGN_CENTER)
    end
end

vgui.Register("ixCrashScreen", PANEL, "DPanel")
