local PLUGIN = PLUGIN

PLUGIN.sunInfo = PLUGIN.sunInfo or nil

function PLUGIN:IsNightTime()
    if ( StormFox2 and StormFox2.Time ) then // StormFox2
        return StormFox2.Time.IsNight()
    elseif ( SW ) then // Simple Weather
        return ( SW.Time >= 23 or SW.Time <= 4 )
    end

    return false // keep it on if no available weather system
end

function PLUGIN:UpdateGlobalSun()
    for k, v in pairs(ents.FindByClass("env_sun")) do
        local sunPos = v:GetPos()
        local sunAng = v:GetAngles()
        local sunCol = v:GetColor()

        self.sunInfo = {
            pos = sunPos,
            ang = sunAng,
            color = sunCol,
        }
    end
end

function PLUGIN:GetSunPos()
    local sunInfo = util.GetSunInfo()
    local pitch, roll, yaw
    pitch = sunInfo.direction:Angle().pitch + 90
    yaw = sunInfo.direction:Angle().yaw
    roll = sunInfo.direction:Angle().roll

    local offset = Vector(0, 0, 1)
    offset:Rotate(Angle(pitch, 0, 0))
    offset:Rotate(Angle(0, yaw, roll))
    offset = offset * 32768

    return GetViewEntity():GetPos() + offset
end

function PLUGIN:CreateProjectedTexture()
    local projectedTexture = self.projectedTexture
    if ( IsValid(projectedTexture) ) then
        projectedTexture:Remove()
    end

    // Create a new projected texture
    projectedTexture = ProjectedTexture()
    projectedTexture:SetTexture("minervahl2rp/mask_center")
    projectedTexture:SetConstantAttenuation(1)
    projectedTexture:SetEnableShadows(true)
    projectedTexture:SetFOV(10)
    projectedTexture:SetLinearAttenuation(0)
    projectedTexture:SetNearZ(49152 / 2)
    projectedTexture:SetQuadraticAttenuation(0)
    projectedTexture:SetShadowFilter(0.2)
    projectedTexture:SetBrightness(0.5)
    projectedTexture:SetFarZ(49152)
    projectedTexture:Update()

    self.projectedTexture = projectedTexture
end

function PLUGIN:CreateProjectedTextureRing()
    local projectedTextureRing = self.projectedTextureRing
    if ( IsValid(projectedTextureRing) ) then
        projectedTextureRing:Remove()
    end

    // Create a new projected texture
    projectedTextureRing = ProjectedTexture()
    projectedTextureRing:SetTexture("minervahl2rp/mask_ring")
    projectedTextureRing:SetConstantAttenuation(1)
    projectedTextureRing:SetEnableShadows(false)
    projectedTextureRing:SetFOV(60)
    projectedTextureRing:SetLinearAttenuation(0)
    projectedTextureRing:SetNearZ(49152 / 2)
    projectedTextureRing:SetQuadraticAttenuation(0)
    projectedTextureRing:SetShadowFilter(0.5)
    projectedTextureRing:SetBrightness(0.75)
    projectedTextureRing:SetFarZ(49152)
    projectedTextureRing:Update()

    self.projectedTextureRing = projectedTextureRing
end

local lerpSunAngles
local lerpSunPos
function PLUGIN:UpdateProjectedTextures()
    local projectedTexture = self.projectedTexture
    local projectedTextureRing = self.projectedTextureRing

    // Get the position and color of the sun
    local sunInfo = util.GetSunInfo()
    local pitch, roll, yaw
    pitch = sunInfo.direction:Angle().pitch + 180
    yaw = sunInfo.direction:Angle().yaw
    roll = sunInfo.direction:Angle().roll

    local sunPos = self:GetSunPos()
    local sunColor = self.sunInfo.color or Vector(1.0, 0.90, 0.80, 1.0):ToColor()

    if not ( lerpSunAngles ) then
        lerpSunAngles = Angle(pitch, yaw, roll)
    end

    if not ( lerpSunPos ) then
        lerpSunPos = sunPos
    end

    lerpSunAngles = LerpAngle(0.01, lerpSunAngles, Angle(pitch, yaw, roll))
    lerpSunPos = LerpVector(0.01, lerpSunPos, sunPos)

    if ( projectedTexture ) then
        projectedTexture:SetAngles(lerpSunAngles)
        projectedTexture:SetPos(lerpSunPos)
        projectedTexture:SetColor(sunColor)
        projectedTexture:Update()
    end

    if ( projectedTextureRing ) then
        projectedTextureRing:SetAngles(lerpSunAngles)
        projectedTextureRing:SetPos(lerpSunPos)
        projectedTextureRing:SetColor(sunColor)
        projectedTextureRing:Update()
    end
end

if ( timer.Exists("ixUpdateProjectedTextures") ) then
    timer.Remove("ixUpdateProjectedTextures")
end

function PLUGIN:Think()
    self:UpdateGlobalSun()

    if ( self:IsNightTime() ) then
        if ( self.projectedTexture ) then
            self.projectedTexture:Remove()
        end
    
        if ( self.projectedTextureRing ) then
            self.projectedTextureRing:Remove()
        end

        return
    end
    
    if ( ix.option.Get("realTimeLightingEnabled") ) then
        // might be unefficient but meh
        if not ( self.sunInfo ) then
            return
        end

        self:CreateProjectedTexture()
        self:UpdateProjectedTextures()
    else
        if ( self.projectedTexture ) then
            self.projectedTexture:Remove()
        end
    
        if ( self.projectedTextureRing ) then
            self.projectedTextureRing:Remove()
        end
    end
end