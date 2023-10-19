include("shared.lua")

surface.CreateFont("ShopTerminalFont", {
    font = "Verdana",
    size = 12,
    weight = 128,
    antialias = true
})

function ENT:Draw()
    self:DrawModel()

    local ang = self:GetAngles()
    local pos = self:GetPos() + ang:Up() * 48 + ang:Right() * -5 + ang:Forward() * -9.75
    ang:RotateAroundAxis(ang:Forward(), 42)

    cam.Start3D2D(pos, ang, 0.1)
        local width, height = 155, 77

        surface.SetDrawColor(Color(16, 16, 16))
        surface.DrawRect(0, 0, width, height)

        surface.SetDrawColor(Color(255, 255, 255, 16))
        surface.DrawRect(0, height / 2 + math.sin(CurTime() * 4) * height / 2, width, 1)

        local alpha = 191 + 64 * math.sin(CurTime() * 4)
        if not ( self:GetNetVar("InUse", false) ) then
            draw.SimpleText("Shop Terminal", "ShopTerminalFont", width / 2, 25, Color(90, 210, 255, alpha), TEXT_ALIGN_CENTER)
            draw.SimpleText("Waiting for input", "ShopTerminalFont", width / 2, height - 16, Color(205, 255, 180, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(LocalPlayer():SteamID64(), "ShopTerminalFont", 5, 36, Color(90, 210, 255, alpha))
            draw.SimpleText("Validating Input...", "ShopTerminalFont", 5, 46, Color(102, 255, 255, alpha))
        end
    cam.End3D2D()
end