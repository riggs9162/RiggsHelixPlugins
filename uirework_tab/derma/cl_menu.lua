
local animationTime = 1
local matrixZScale = Vector(1, 1, 0.0001)

DEFINE_BASECLASS("ixSubpanelParent")
local PANEL = {}

AccessorFunc(PANEL, "bCharacterOverview", "CharacterOverview", FORCE_BOOL)

function PANEL:Init()
	if (IsValid(ix.gui.menu)) then
		ix.gui.menu:Remove()
	end

	ix.gui.menu = self

	-- properties
	self.manualChildren = {}
	self.noAnchor = CurTime() + 0.4
	self.anchorMode = true
	self.rotationOffset = Angle(0, 180, 0)
	self.projectedTexturePosition = Vector(0, 0, 6)
	self.projectedTextureRotation = Angle(-45, 60, 0)

	self.bCharacterOverview = false
	self.bOverviewOut = false
	self.overviewFraction = 0

	self.currentAlpha = 0
	self.currentBlur = 0

	self.currentSubpanelX = ScreenScale(16)
	self.targetSubpanelX = ScreenScale(16)
	self.padding = ScreenScale(16)

	-- setup
	self:SetSize(ScrW(), ScrH())
	self:SetPos(0, 0)

	-- main button panel
	self.buttons = self:Add("Panel")
	self.buttons:SetSize(self:GetWide(), self.padding)
	self.buttons:Dock(TOP)
	self.buttons:SetPaintedManually(true)
	self.buttons.Paint = function(panel, width, height)
		surface.SetDrawColor(ColorAlpha(ix.config.Get("color"), 66))
		surface.DrawRect(0, height - ScreenScale(1), width, ScreenScale(1))
	end

	-- tabs
	self.tabs = self.buttons:Add("Panel")
	self.tabs.buttons = {}
	self.tabs:Dock(FILL)
	self:PopulateTabs()

	local close = self.buttons:Add("ixMenuSelectionButtonTop")
	close:SetText("X")
	close:SetTextInset(0, 0)
	close:SetContentAlignment(5)
	close:SizeToContents()
	close:Dock(RIGHT)
	close:SetBackgroundColor(derma.GetColor("Error", close))
	close:SetButtonList(self.tabs.buttons)
	close.DoClick = function()
		self:Remove()
	end

	local characters = self.buttons:Add("ixMenuSelectionButtonTop")
	characters:SetText("<")
	characters:SetTextInset(0, 0)
	characters:SetContentAlignment(5)
	characters:SizeToContents()
	characters:Dock(LEFT)
	characters:SetBackgroundColor(derma.GetColor("Info", close))
	characters:SetButtonList(self.tabs.buttons)
	characters.DoClick = function()
		self:Remove()
		vgui.Create("ixCharMenu")
	end

	self:MakePopup()
	self:OnOpened()
end

function PANEL:OnOpened()
	self:SetAlpha(0)

	self:CreateAnimation(animationTime, {
		target = {currentAlpha = 255},
		easing = "outQuint",

		Think = function(animation, panel)
			panel:SetAlpha(panel.currentAlpha)
		end
	})
end

function PANEL:GetActiveTab()
	return (self:GetActiveSubpanel() or {}).subpanelName
end

function PANEL:TransitionSubpanel(id)
	local lastSubpanel = self:GetActiveSubpanel()

	-- don't transition to the same panel
	if (IsValid(lastSubpanel) and lastSubpanel.subpanelID == id) then
		return
	end

	local subpanel = self:GetSubpanel(id)

	if (IsValid(subpanel)) then
		if (!subpanel.bPopulated) then
			-- we need to set the size of the subpanel if it's a section since it will be 0, 0
			if (subpanel.sectionParent) then
				subpanel:SetSize(self:GetStandardSubpanelSize())
			end

			local info = subpanel.info
			subpanel.Paint = nil

			if (istable(info) and info.Create) then
				info:Create(subpanel)
			elseif (isfunction(info)) then
				info(subpanel)
			end

			hook.Run("MenuSubpanelCreated", subpanel.subpanelName, subpanel)
			subpanel.bPopulated = true
		end

		-- only play whoosh sound only when the menu was already open
		if (IsValid(lastSubpanel)) then
			LocalPlayer():EmitSound("Helix.Whoosh")
		end

		self:SetActiveSubpanel(id)
	end

	subpanel = self:GetActiveSubpanel()

	local info = subpanel.info
	local bHideBackground = istable(info) and (info.bHideBackground != nil and info.bHideBackground or false) or false

	if (bHideBackground) then
		self:HideBackground()
	else
		self:ShowBackground()
	end

	-- call hooks if we've changed subpanel
	if (IsValid(lastSubpanel) and istable(lastSubpanel.info) and lastSubpanel.info.OnDeselected) then
		lastSubpanel.info:OnDeselected(lastSubpanel)
	end

	if (IsValid(subpanel) and istable(subpanel.info) and subpanel.info.OnSelected) then
		subpanel.info:OnSelected(subpanel)
	end

	ix.gui.lastMenuTab = id
end

function PANEL:SetCharacterOverview(bValue, length)
	bValue = tobool(bValue)
	length = length or animationTime

	if (bValue) then
		if (!IsValid(self.projectedTexture)) then
			self.projectedTexture = ProjectedTexture()
		end

		local faction = ix.faction.indices[LocalPlayer():Team()]
		local color = faction and faction.color or color_white

		self.projectedTexture:SetEnableShadows(false)
		self.projectedTexture:SetNearZ(12)
		self.projectedTexture:SetFarZ(64)
		self.projectedTexture:SetFOV(90)
		self.projectedTexture:SetColor(color)
		self.projectedTexture:SetTexture("effects/flashlight/soft")

		self:CreateAnimation(length, {
			index = 3,
			target = {overviewFraction = 1},
			easing = "outQuint",
			bIgnoreConfig = true
		})

		self.bOverviewOut = false
		self.bCharacterOverview = true
	else
		self:CreateAnimation(length, {
			index = 3,
			target = {overviewFraction = 0},
			easing = "outQuint",
			bIgnoreConfig = true,

			OnComplete = function(animation, panel)
				panel.bCharacterOverview = false

				if (IsValid(panel.projectedTexture)) then
					panel.projectedTexture:Remove()
				end
			end
		})

		self.bOverviewOut = true
	end
end

function PANEL:GetOverviewInfo(origin, angles, fov)
	local originAngles = Angle(0, angles.yaw, angles.roll)
	local target = LocalPlayer():GetObserverTarget()
	local fraction = self.overviewFraction
	local bDrawPlayer = ((fraction > 0.2) or (!self.bOverviewOut and (fraction > 0.2))) and !IsValid(target)
    local forward = originAngles:Forward() * 64 + originAngles:Right() * 32 + originAngles:Up() * 8

	local newOrigin

	if (IsValid(target)) then
		newOrigin = target:GetPos() + forward
	else
		newOrigin = origin - LocalPlayer():OBBCenter() * 0.6 + forward
	end

	local newAngles = originAngles + self.rotationOffset
	newAngles.pitch = -5
	newAngles.roll = 0
	newAngles.yaw = newAngles.yaw - 45

	return LerpVector(fraction, origin, newOrigin), LerpAngle(fraction, angles, newAngles), Lerp(fraction, fov, 50), bDrawPlayer
end

function PANEL:HideBackground()
	self:CreateAnimation(animationTime, {
		index = 2,
		target = {currentBlur = 0},
		easing = "outQuint"
	})
end

function PANEL:ShowBackground()
	self:CreateAnimation(animationTime, {
		index = 2,
		target = {currentBlur = 1},
		easing = "outQuint"
	})
end

function PANEL:GetStandardSubpanelSize()
	return ScrW() - self.padding * 2, ScrH() - self.padding * 2 - self.buttons:GetTall() * 0.5
end

function PANEL:SetupTab(name, info, sectionParent)
	local bTable = istable(info)
	local buttonColor = (bTable and info.buttonColor) or (ix.config.Get("color") or Color(140, 140, 140, 255))
	local bDefault = (bTable and info.bDefault) or false
	local qualifiedName = sectionParent and (sectionParent.name .. "/" .. name) or name

	-- setup subpanels without populating them so we can retain the order
	local subpanel = self:AddSubpanel(qualifiedName, true)
	local id = subpanel.subpanelID
	subpanel.info = info
	subpanel.sectionParent = sectionParent and qualifiedName
	subpanel:SetPaintedManually(true)
	subpanel:SetTitle(ix.config.Get("tabMenuTitle") and name or nil)

	subpanel:SetSize(self:GetStandardSubpanelSize())

	subpanel:Center()
	subpanel:SetY(self:GetTall() - subpanel:GetTall() - self.padding * 0.75)

    if not (sectionParent) then
        -- this is called while the subpanel has not been populated
        subpanel.Paint = function(panel, width, height)
            derma.SkinFunc("PaintPlaceholderPanel", panel, width, height)
        end
    end

	local button

	if (sectionParent) then
		button = sectionParent:AddSection(L(name))
		name = qualifiedName
	else
		button = self.tabs:Add("ixMenuSelectionButtonTop")
		button:SetText(L(name))
		button:SetButtonList(self.tabs.buttons)
		button:SetBackgroundColor(buttonColor)
	end

	button:SetFont("ixMenuButtonFontSmall") // trust me, u wanna keep it small :skull:

	button:Dock(LEFT)
	button:SetTextInset(0, 0)
	button:SetContentAlignment(5)
	button:SizeToContents()

	button.name = name
	button.id = id
	button.OnSelected = function()
		self:TransitionSubpanel(id)
	end

	if (bTable and info.PopulateTabButton) then
		info:PopulateTabButton(button)
	end

	-- don't allow sections in sections
	if (sectionParent or !bTable or !info.Sections) then
		return bDefault, button, subpanel
	end

	-- create button sections
	for sectionName, sectionInfo in pairs(info.Sections) do
		self:SetupTab(sectionName, sectionInfo, button)
	end

	return bDefault, button, subpanel
end

function PANEL:PopulateTabs()
	local default
	local tabs = {}

	hook.Run("CreateMenuButtons", tabs)

	// remove the shitty line on the settings
	tabs["settings"].PopulateTabButton = function(info, button)
		local menu = ix.gui.menu

		if (!IsValid(menu)) then
			return
		end

		DEFINE_BASECLASS("ixMenuButton")
		button:SetZPos(9999)
	end

	for name, info in SortedPairs(tabs) do
		local bDefault, button = self:SetupTab(name, info)

		if (bDefault) then
			default = button
		end
	end

	if (ix.gui.lastMenuTab) then
		for i = 1, #self.tabs.buttons do
			local button = self.tabs.buttons[i]

			if (button.id == ix.gui.lastMenuTab) then
				default = button
				break
			end
		end
	end

	if (!IsValid(default) and #self.tabs.buttons > 0) then
		default = self.tabs.buttons[1]
	end

	if (IsValid(default)) then
		default:SetSelected(true)
		self:SetActiveSubpanel(default.id, 0)
	end

	self.buttons:MoveToFront()
end

function PANEL:AddManuallyPaintedChild(panel)
	panel:SetParent(self)
	panel:SetPaintedManually(panel)

	self.manualChildren[#self.manualChildren + 1] = panel
end

function PANEL:OnKeyCodePressed(key)
	self.noAnchor = CurTime() + 0.5

	if (key == KEY_TAB) then
		self:Remove()
	end
end

function PANEL:Think()
	if (IsValid(self.projectedTexture)) then
		local forward = LocalPlayer():GetForward()
		forward.z = 0

		local right = LocalPlayer():GetRight()
		right.z = 0

		self.projectedTexture:SetBrightness(self.overviewFraction * 4)
		self.projectedTexture:SetPos(LocalPlayer():GetPos() + right * 16 - forward * 8 + self.projectedTexturePosition)
		self.projectedTexture:SetAngles(forward:Angle() + self.projectedTextureRotation)
		self.projectedTexture:Update()
	end

	if (self.bClosing) then
		return
	end

	local bTabDown = input.IsKeyDown(KEY_TAB)

	if (bTabDown and (self.noAnchor or CurTime() + 0.4) < CurTime() and self.anchorMode) then
		self.anchorMode = false
		surface.PlaySound("buttons/lightswitch2.wav")
	end

	if ((!self.anchorMode and !bTabDown) or gui.IsGameUIVisible()) then
		self:Remove()
	end
end

local vignette = ix.util.GetMaterial("helix/gui/vignette.png")
function PANEL:Paint(width, height)
	derma.SkinFunc("PaintMenuBackground", self, width, height, self.currentBlur / 5)

	surface.SetDrawColor(0, 0, 0, self.currentAlpha)
	surface.SetMaterial(vignette)
	surface.DrawTexturedRect(0, 0, width, height)
	surface.DrawTexturedRect(0, 0, width, height)

	BaseClass.Paint(self, width, height)

	self:PaintSubpanels(width, height)
	self.buttons:PaintManual()

	for i = 1, #self.manualChildren do
		self.manualChildren[i]:PaintManual()
	end

	if (IsValid(ix.gui.inv1) and ix.gui.inv1.childPanels) then
		for i = 1, #ix.gui.inv1.childPanels do
			local panel = ix.gui.inv1.childPanels[i]

			if (IsValid(panel)) then
				panel:PaintManual()
			end
		end
	end
end

function PANEL:Remove()
	self.bClosing = true
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	self:SetCharacterOverview(false, animationTime * 0.5)

	-- remove input from opened child panels since they grab focus
	if (IsValid(ix.gui.inv1) and ix.gui.inv1.childPanels) then
		for i = 1, #ix.gui.inv1.childPanels do
			local panel = ix.gui.inv1.childPanels[i]

			if (IsValid(panel)) then
				panel:SetMouseInputEnabled(false)
				panel:SetKeyboardInputEnabled(false)
			end
		end
	end

	CloseDermaMenus()
	gui.EnableScreenClicker(false)

	self:CreateAnimation(animationTime * 0.5, {
		index = 2,
		target = {currentBlur = 0},
		easing = "outQuint"
	})

	self:CreateAnimation(animationTime * 0.5, {
		target = {currentAlpha = 0},
		easing = "outQuint",

		-- we don't animate the blur because blurring doesn't draw things
		-- with amount < 1 very well, resulting in jarring transition
		Think = function(animation, panel)
			panel:SetAlpha(panel.currentAlpha)
		end,

		OnComplete = function(animation, panel)
			if (IsValid(panel.projectedTexture)) then
				panel.projectedTexture:Remove()
			end

			BaseClass.Remove(panel)
		end
	})
end

vgui.Register("ixMenu", PANEL, "ixSubpanelParent")

if (IsValid(ix.gui.menu)) then
	ix.gui.menu:Remove()

	timer.Simple(0, function()
		vgui.Create("ixMenu")
	end)
end

ix.gui.lastMenuTab = nil
