
local animationTime = 0.5

-- selection menu button
DEFINE_BASECLASS("ixMenuButton")
PANEL = {}

AccessorFunc(PANEL, "backgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "selected", "Selected", FORCE_BOOL)
AccessorFunc(PANEL, "buttonList", "ButtonList")

function PANEL:Init()
	self:DockMargin(0, 0, 0, 0)

	self.backgroundColor = color_white
	self.selected = false
	self.buttonList = {}
	self.sectionPanel = nil -- sub-sections this button has; created only if it has any sections
end

local gradient = surface.GetTextureID("vgui/gradient-u")
function PANEL:PaintBackground(width, height)
	local alpha = self.selected and 255 or self.currentBackgroundAlpha

	surface.SetTexture(gradient)
	surface.SetDrawColor(ColorAlpha(self.backgroundColor, alpha))
	surface.DrawTexturedRect(0, 0, width, height)
end

function PANEL:SetSelected(bValue, bSelectedSection)
	self.selected = bValue

	if (bValue) then
		self:OnSelected()

		if (self.sectionPanel) then
			self.sectionPanel:Show()
		elseif (self.sectionParent) then
			self.sectionParent.sectionPanel:Show()
		end
	elseif (self.sectionPanel and self.sectionPanel:IsVisible() and !bSelectedSection) then
		self.sectionPanel:Hide()
	end
end

function PANEL:SetButtonList(list, bNoAdd)
	if (!bNoAdd) then
		list[#list + 1] = self
	end

	self.buttonList = list
end

function PANEL:GetSectionPanel()
	return self.sectionPanel
end

function PANEL:AddSection(name)
	if (!IsValid(self.sectionPanel)) then
		-- add section panel to regular button list
		self.sectionPanel = vgui.Create("ixMenuSelectionListTop", self:GetParent())
		self.sectionPanel:Dock(self:GetDock())
		self.sectionPanel:SetParentButton(self)
	end

	return self.sectionPanel:AddButton(name, self.buttonList)
end

function PANEL:OnMousePressed(key)
	for _, v in pairs(self.buttonList) do
		if (IsValid(v) and v != self) then
			v:SetSelected(false, self.sectionParent == v)
		end
	end

	self:SetSelected(true)
	BaseClass.OnMousePressed(self, key)
end

function PANEL:OnSelected()
end

vgui.Register("ixMenuSelectionButtonTop", PANEL, "ixMenuButton")

-- collapsable list for menu button sections
PANEL = {}
AccessorFunc(PANEL, "parent", "ParentButton")

function PANEL:Init()
	self.parent = nil -- button that is responsible for controlling this list
	self.width = 0
	self.targetWidth = 0

	self:SetVisible(false)
	self:SetWide(0)
end

function PANEL:AddButton(name, buttonList)
	assert(IsValid(self.parent), "attempted to add button to ixMenuSelectionList without a ParentButton")
	assert(buttonList ~= nil, "attempted to add button to ixMenuSelectionList without a buttonList")

	local button = self:Add("ixMenuSelectionButtonTop")
	button.sectionParent = self.parent
	button:Dock(LEFT)
	button:DockMargin(0, 0, 0, 0)
	button:SetText(name)
	button:SetTextInset(0, 0)
	button:SetFont("ixMenuButtonFontSmall")
	button:SetContentAlignment(5)
	button:SizeToContents()
	button:SetButtonList(buttonList)
	button:SetBackgroundColor(self.parent:GetBackgroundColor())

	self.targetWidth = self.targetWidth + button:GetWide()

	return button
end

function PANEL:Show()
	self:SetVisible(true)

	self:CreateAnimation(animationTime, {
		index = 1,
		target = {
			width = self.targetWidth + 2 -- +2 for padding
		},
		easing = "outQuart",

		Think = function(animation, panel)
			panel:SetWide(panel.width)
		end
	})
end

function PANEL:Hide()
	self:CreateAnimation(animationTime, {
		index = 1,
		target = {
			width = 0
		},
		easing = "outQuint",

		Think = function(animation, panel)
			panel:SetWide(panel.width)
		end,

		OnComplete = function(animation, panel)
			panel:SetVisible(false)
		end
	})
end

vgui.Register("ixMenuSelectionListTop", PANEL, "Panel")
