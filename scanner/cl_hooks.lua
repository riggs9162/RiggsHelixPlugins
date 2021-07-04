local PLUGIN = PLUGIN

local PICTURE_WIDTH = PLUGIN.PICTURE_WIDTH
local PICTURE_HEIGHT = PLUGIN.PICTURE_HEIGHT
local PICTURE_WIDTH2 = PICTURE_WIDTH * 0.5
local PICTURE_HEIGHT2 = PICTURE_HEIGHT * 0.5

surface.CreateFont("ixScannerFont", {
	font = "Lucida Sans Typewriter",
	antialias = false,
	outline = true,
	weight = 800,
	size = 18
})

local view = {}
local zoom = 0
local deltaZoom = zoom
local nextClick = 0
local hidden = false
local data = {}

local CLICK = "buttons/button18.wav"

local blackAndWhite = {
	["$pp_colour_addr"] = 0, 
	["$pp_colour_addg"] = 0, 
	["$pp_colour_addb"] = 0, 
	["$pp_colour_brightness"] = 0, 
	["$pp_colour_contrast"] = 1.5, 
	["$pp_colour_colour"] = 0, 
	["$pp_colour_mulr"] = 0, 
	["$pp_colour_mulg"] = 0, 
	["$pp_colour_mulb"] = 0
}

function PLUGIN:CalcView(client, origin, angles, fov)
	if not ix then return end
	if IsValid(ix.gui.menu) or IsValid(ix.gui.characterMenu) then return false end
	local entity = client:GetViewEntity()

	if (IsValid(client) and (client:GetCharacter():GetClass() == CLASS_CP_SCANNER)) then
		if not (input.IsKeyDown(KEY_C)) then
			view.angles = client:GetAimVector():Angle()
			if (hidden) then
				view.fov = fov - deltaZoom
			else
				view.fov = fov
			end

			if (math.abs(deltaZoom - zoom) > 5 and nextClick < RealTime()) and (hidden) then
				nextClick = RealTime() + 0.05
				client:EmitSound("common/talk.wav", 50, 180)
			end

			return view
		end
	end
end

function PLUGIN:InputMouseApply(command, x, y, angle)
	if (hidden) then
		zoom = math.Clamp(zoom + command:GetMouseWheel() * 1.5, 0, 40)
		deltaZoom = Lerp(FrameTime() * 2, deltaZoom, zoom)
	end
end

function PLUGIN:PreDrawOpaqueRenderables()
	local viewEntity = LocalPlayer():GetViewEntity()

	if (IsValid(self.lastViewEntity) and self.lastViewEntity != viewEntity) then
		self.lastViewEntity:SetNoDraw(false)
		self.lastViewEntity = nil
		LocalPlayer():EmitSound(CLICK, 50, 120)
	end

	if (IsValid(viewEntity) and viewEntity:GetClass():find("scanner")) then
		viewEntity:SetNoDraw(true)

		if (self.lastViewEntity ~= viewEntity) then
			viewEntity:EmitSound(CLICK, 50, 140)
		end

		self.lastViewEntity = viewEntity

		hidden = true
	elseif (hidden) then
		hidden = false
	end
end

function PLUGIN:ShouldDrawCrosshair()
	if (hidden) then
		return false
	end
end

function PLUGIN:AdjustMouseSensitivity()
	if (hidden) then
		return 0.8
	end
end

function PLUGIN:HUDPaint()
	if (not hidden) then return end

	local scrW, scrH = surface.ScreenWidth() * 0.5, surface.ScreenHeight() * 0.5
	local x, y = scrW - PICTURE_WIDTH2, scrH - PICTURE_HEIGHT2

	if (self.lastPic and self.lastPic >= CurTime()) then
		local delay = 15
		local percent = math.Round(math.TimeFraction(self.lastPic - delay, self.lastPic, CurTime()), 2) * 100
		local glow = math.sin(RealTime() * 15) * 25

		draw.SimpleText("RE-CHARGING: "..percent.."%", "ixScannerFont", x, y - 24, Color(255 + glow, 100 + glow, 25, 250))
	end

	local position = LocalPlayer():GetPos()
	local angle = LocalPlayer():GetAimVector():Angle()
	local zone = LocalPlayer():GetArea() or "unknown"

	draw.SimpleText("POS ("..math.floor(position[1])..", "..math.floor(position[2])..", "..math.floor(position[3])..")", "ixScannerFont", x + 8, y + 8, color_white)
	draw.SimpleText("ANG ("..math.floor(angle[1])..", "..math.floor(angle[2])..", "..math.floor(angle[3])..")", "ixScannerFont", x + 8, y + 24, color_white)
	draw.SimpleText("ID  ("..LocalPlayer():Name()..")", "ixScannerFont", x + 8, y + 40, color_white)
	draw.SimpleText("ZM  ("..(math.Round(zoom / 40, 2) * 100).."%)", "ixScannerFont", x + 8, y + 56, color_white)
	draw.SimpleText("ZONE("..(zone)..")", "ixScannerFont", x + 8, y + 88, color_white)

	if (IsValid(self.lastViewEntity)) then
		data.start = self.lastViewEntity:GetPos()
		data.endpos = data.start + LocalPlayer():GetAimVector() * 500
		data.filter = self.lastViewEntity

		local entity = util.TraceLine(data).Entity

		if (IsValid(entity) and entity:IsPlayer()) then
			entity = entity:Name()
		else
			entity = "NULL"
		end

		draw.SimpleText("TRG ("..entity..")", "ixScannerFont", x + 8, y + 72, color_white)
	end

	surface.SetDrawColor(235, 235, 235, 230)

	surface.DrawLine(0, scrH, x - 128, scrH)
	surface.DrawLine(scrW + PICTURE_WIDTH2 + 128, scrH, ScrW(), scrH)
	surface.DrawLine(scrW, 0, scrW, y - 128)
	surface.DrawLine(scrW, scrH + PICTURE_HEIGHT2 + 128, scrW, ScrH())

	surface.DrawLine(x, y, x + 128, y)
	surface.DrawLine(x, y, x, y + 128)

	x = scrW + PICTURE_WIDTH2

	surface.DrawLine(x, y, x - 128, y)
	surface.DrawLine(x, y, x, y + 128)

	x = scrW - PICTURE_WIDTH2
	y = scrH + PICTURE_HEIGHT2

	surface.DrawLine(x, y, x + 128, y)
	surface.DrawLine(x, y, x, y - 128)

	x = scrW + PICTURE_WIDTH2

	surface.DrawLine(x, y, x - 128, y)
	surface.DrawLine(x, y, x, y - 128)

	surface.DrawLine(scrW - 48, scrH, scrW - 8, scrH)
	surface.DrawLine(scrW + 48, scrH, scrW + 8, scrH)
	surface.DrawLine(scrW, scrH - 48, scrW, scrH - 8)
	surface.DrawLine(scrW, scrH + 48, scrW, scrH + 8)
end

function PLUGIN:RenderScreenspaceEffects()
	if (not hidden) then return end
	blackAndWhite["$pp_colour_brightness"] = -0.05 + math.sin(RealTime() * 5) * 0.01
	DrawColorModify(blackAndWhite)
end

function PLUGIN:PlayerBindPress(client, bind, pressed)
	bind = bind:lower()
	if (bind:find("attack") and
		pressed and
		hidden and
		IsValid(self.lastViewEntity)) then
		self:takePicture()
		return true
	end
end