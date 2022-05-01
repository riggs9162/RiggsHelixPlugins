local PLUGIN = PLUGIN

include("shared.lua")

local knots = {
    Vector(-20, 0, 0),
    Vector(-30, 0, 0),
    Vector(120, 0, 0),
    Vector(90, 0, 0),
}

function ENT:Think()
    local velocity = self:GetVelocity()
    local lengthSqr = velocity:LengthSqr()
    self.wheel = self.wheel or 360
    self.wheel = self.wheel - math.min((lengthSqr / 80) + 250, 900)
        * FrameTime()
    if (self.wheel < 0) then
        self.wheel = 360
    end

    self:SetPoseParameter("dynamo_wheel", self.wheel)

    local t = velocity.z / self.maxSpeed
    self.tail = math.BSplinePoint(t, knots, 1)
    self.realTail = Lerp(FrameTime() * 5, self.realTail or 0, self.tail.x)
    self:SetPoseParameter("tail_control", self.realTail)

    local pilot = self:GetPilot()
    local angles = self:GetAngles()
    local goalAngles = IsValid(pilot) and pilot:EyeAngles() or angles

    local hDiff = math.AngleDifference(goalAngles.y, angles.y) / 45
    local vDiff = math.AngleDifference(goalAngles.p, angles.p) / 45
    self:SetPoseParameter("flex_horz", hDiff * 20)
    self:SetPoseParameter("flex_vert", vDiff * 20)

    self:playFlySound()

    if (self.sound) then
        self.sound:ChangePitch(math.min(80 + (lengthSqr / 10000)*20, 255), 0.5)
    end
end

function ENT:playFlySound()
    if (not self.sound) then
        local source = "npc/scanner/cbot_fly_loop.wav"
        if (self:GetModel():find("shield_scanner")) then
            source = "npc/scanner/combat_scan_loop6.wav"
        end
        self.sound = CreateSound(self, source)
        self.sound:PlayEx(0.5, 100)
    elseif (not self.sound:IsPlaying()) then
        self.sound:Play()
    end
end

function ENT:OnRemove()
    if (self.sound) then
        self.sound:Stop()
        self.sound = nil
    end
end

net.Receive("ixScannerFlash", function()
    local entity = net.ReadEntity()
    if (IsValid(entity)) then
        local light = DynamicLight(entity:EntIndex())
        if (not light) then return end

        light.pos = entity:GetPos() + entity:GetForward() * 24
        light.r = 255
        light.g = 255
        light.b = 255
        light.brightness = 5
        light.Decay = 5000
        light.Size = 384
        light.DieTime = CurTime() + 1
    end
end)
