local PLUGIN = PLUGIN

function PLUGIN:PopulateCharacterInfo()
    return false
end

function PLUGIN:PopulateImportantCharacterInfo()
    return false
end

function PLUGIN:LoadFonts(font, genericFont)
    surface.CreateFont("ixFactionBoxFont", {
        font = "Arial",
        size = 32,
        weight = 700
    })

    surface.CreateFont("ixFactionBoxFontBlur", {
        font = "Arial",
        size = 32,
        weight = 700,
        blursize = 4
    })
end

local function GetHeadBone(ply)
    local Bip01_Head1 = ply:LookupBone("ValveBiped.Bip01_Head1")
    if ( Bip01_Head1 ) then
        return ply:GetBonePosition(Bip01_Head1)
    end

    local Bip01_Head = ply:LookupBone("ValveBiped.Bip01_Head")
    if ( Bip01_Head ) then
        return ply:GetBonePosition(Bip01_Head)
    end

    return ply:EyePos()
end

local flicker = surface.GetTextureID("effects/flicker_128")
local lerpTable = {}
function PLUGIN:PostPlayerDraw(ply)
    local localPlayer = LocalPlayer()
    if ( ply == localPlayer ) then return end

    local char = ply:GetCharacter()
    if ( !char ) then return end

    local factionData = ix.faction.indices[char:GetFaction()]
    if ( !factionData ) then return end

    if ( !lerpTable[ply] ) then
        lerpTable[ply] = 0
    end

    local trace = util.TraceLine({
        start = localPlayer:GetShootPos(),
        endpos = localPlayer:GetShootPos() + localPlayer:GetAimVector() * 128,
        filter = localPlayer
    })

    lerpTable[ply] = Lerp(FrameTime() * 2, lerpTable[ply], trace.Entity == ply and 1 or 0)

    local alpha = lerpTable[ply]
    if ( alpha <= 0 ) then return end

    local charName = hook.Run("GetCharacterName", ply) or char:GetName()

    local factionName = factionData.name
    local factionColor = factionData.color
    local factionIcon = factionData.icon and ix.util.GetMaterial(factionData.icon) or nil

    local colorBlack = Color(0, 0, 0, 255 * alpha)
    local colorFaction = Color(factionColor.r, factionColor.g, factionColor.b, 255 * alpha)

    local pos = GetHeadBone(ply) + Vector(0, 0, 6)
    local ang = localPlayer:EyeAngles() + Angle(0, 270, 90)
    ang.p = 0

    local x, y = 64, 0
    local width, height = 0, 80

    cam.Start3D2D(pos, ang, 0.1)
        surface.SetFont("ixFactionBoxFont")

        width = (math.max(surface.GetTextSize(charName), surface.GetTextSize(factionName))) + (factionIcon and 96 or 32)
        height = 80

        surface.SetDrawColor(0, 0, 0, 200 * alpha)
        surface.DrawRect(x, y, width, height)

        surface.SetDrawColor(factionColor.r - 50, factionColor.g - 50, factionColor.b - 50, 100 * alpha)
        surface.DrawRect(x, y, width, height)

        surface.SetDrawColor(255, 255, 255, 255 * alpha)
        surface.SetTexture(flicker)
        surface.DrawTexturedRect(x, y, width, height)

        surface.SetDrawColor(factionColor.r, factionColor.g, factionColor.b, 200 * alpha)
        surface.DrawOutlinedRect(x, y, width, height, 2)

        x, y = x + 8, y + 8

        if ( factionIcon ) then
            surface.SetDrawColor(colorFaction)
            surface.SetMaterial(factionIcon)
            surface.DrawTexturedRect(x, y, 64, 64)

            x, y = x + 64 + 8, y + 16
        else
            x, y = x + 8, y + 16
        end

        draw.SimpleText(charName, "ixFactionBoxFontBlur", x, y, colorBlack, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(charName, "ixFactionBoxFontBlur", x, y, colorBlack, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(charName, "ixFactionBoxFont", x, y, colorFaction, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        y = y + 32

        draw.SimpleText(factionName, "ixFactionBoxFontBlur", x, y, colorBlack, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(factionName, "ixFactionBoxFontBlur", x, y, colorBlack, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(factionName, "ixFactionBoxFont", x, y, colorFaction, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end