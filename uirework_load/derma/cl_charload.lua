
-- character load panel
local errorModel = "models/error.mdl"
local PANEL = {}

AccessorFunc(PANEL, "animationTime", "AnimationTime", FORCE_NUMBER)
AccessorFunc(PANEL, "backgroundFraction", "BackgroundFraction", FORCE_NUMBER)

function PANEL:Init()
	local parent = self:GetParent()
	local padding = self:GetPadding()
	local halfWidth = parent:GetWide() * 0.5 - (padding * 2)
	local halfHeight = parent:GetTall() * 0.5 - (padding * 2)
	local modelFOV = (ScrW() > ScrH() * 1.8) and 102 or 78

	self.animationTime = 1
	self.backgroundFraction = 1

	-- main panel
	self.panel = self:AddSubpanel("main")
	self.panel:SetTitle("loadTitle")
	self.panel.title:SetContentAlignment(5)
	self.panel.OnSetActive = function()
		self:CreateAnimation(self.animationTime, {
			index = 2,
			target = {backgroundFraction = 1},
			easing = "outQuint",
		})
	end

	-- character button list
	local bottomButtons = self.panel:Add("Panel")
	bottomButtons:Dock(BOTTOM)

	local back = bottomButtons:Add("ixMenuButton")
	back:Dock(LEFT)
	back:SetText("return")
	back:SetContentAlignment(5)
	back:SizeToContents()
	back.DoClick = function()
		self:SlideDown()
		parent.mainPanel:Undim()
	end

	bottomButtons:SetTall(back:GetTall())

	local deleteButton = bottomButtons:Add("ixMenuButton")
	deleteButton:Dock(RIGHT)
	deleteButton:SetText("delete")
	deleteButton:SetContentAlignment(5)
	deleteButton:SetTextInset(0, 0)
	deleteButton:SizeToContents()
	deleteButton:SetTextColor(derma.GetColor("Error", deleteButton))
	deleteButton.DoClick = function()
		self:SetActiveSubpanel("delete")
	end

	local continueButton = bottomButtons:Add("ixMenuButton")
	continueButton:Dock(FILL)
	continueButton:SetText("choose")
	continueButton:SetContentAlignment(5)
	continueButton:SizeToContents()
	continueButton.DoClick = function()
		self:SlideDown(self.animationTime, function()
			net.Start("ixCharacterChoose")
				net.WriteUInt(self.character:GetID(), 32)
			net.SendToServer()
		end, true)
	end

	self.characterList = self.panel:Add("DHorizontalScroller")
	self.characterList:Dock(FILL)
	self.characterList.buttons = {}
	self.characterList.btnLeft.Paint = function() end
	self.characterList.btnRight.Paint = function() end

	-- character deletion panel
	self.delete = self:AddSubpanel("delete")
	self.delete:SetTitle(nil)
	self.delete.OnSetActive = function()
		self.deleteModel:SetModel(self.character:GetModel())
		self:CreateAnimation(self.animationTime, {
			index = 2,
			target = {backgroundFraction = 0},
			easing = "outQuint"
		})
	end

	local deleteInfo = self.delete:Add("Panel")
	deleteInfo:SetSize(parent:GetWide() * 0.5, parent:GetTall())
	deleteInfo:Dock(LEFT)

	local deleteReturn = deleteInfo:Add("ixMenuButton")
	deleteReturn:Dock(BOTTOM)
	deleteReturn:SetText("no")
	deleteReturn:SizeToContents()
	deleteReturn.DoClick = function()
		self:SetActiveSubpanel("main")
	end

	local deleteConfirm = self.delete:Add("ixMenuButton")
	deleteConfirm:Dock(BOTTOM)
	deleteConfirm:SetText("yes")
	deleteConfirm:SetContentAlignment(6)
	deleteConfirm:SizeToContents()
	deleteConfirm:SetTextColor(derma.GetColor("Error", deleteConfirm))
	deleteConfirm.DoClick = function()
		local id = self.character:GetID()

		parent:ShowNotice(1, L("deleteComplete", self.character:GetName()))
		self:Populate(id)
		self:SetActiveSubpanel("main")

		net.Start("ixCharacterDelete")
			net.WriteUInt(id, 32)
		net.SendToServer()
	end

	self.deleteModel = deleteInfo:Add("ixModelPanel")
	self.deleteModel:Dock(FILL)
	self.deleteModel:SetModel(errorModel)
	self.deleteModel:SetFOV(modelFOV)
	self.deleteModel.PaintModel = self.deleteModel.Paint

	local deleteNag = self.delete:Add("Panel")
	deleteNag:SetTall(parent:GetTall() * 0.5)
	deleteNag:Dock(BOTTOM)

	local deleteTitle = deleteNag:Add("DLabel")
	deleteTitle:SetFont("ixTitleFont")
	deleteTitle:SetText(L("areYouSure"):utf8upper())
	deleteTitle:SetTextColor(ix.config.Get("color"))
	deleteTitle:SizeToContents()
	deleteTitle:Dock(TOP)

	local deleteText = deleteNag:Add("DLabel")
	deleteText:SetFont("ixMenuButtonFont")
	deleteText:SetText(L("deleteConfirm"))
	deleteText:SetTextColor(color_white)
	deleteText:SetContentAlignment(7)
	deleteText:Dock(FILL)

	-- finalize setup
	self:SetActiveSubpanel("main", 0)
end

function PANEL:OnCharacterDeleted(character)
	if (self.bActive and #ix.characters == 0) then
		self:SlideDown()
	end
end

function PANEL:Populate(ignoreID)
	for _, v in ipairs(self.characterList.buttons) do
		v:Remove()
	end

	self.characterList.buttons = {}

	local bSelected

	-- loop backwards to preserve order since we're docking to the bottom
	for i = 1, #ix.characters do
		local id = ix.characters[i]
		local character = ix.char.loaded[id]

		if (!character or character:GetID() == ignoreID) then
			continue
		end

		local index = character:GetFaction()
		local faction = ix.faction.indices[index]
		local color = faction and faction.color or color_white

		local button = self.characterList:Add("ixMenuSelectionButton")
		button:Dock(LEFT)
		button:SetBackgroundColor(color)
		button:SetText("")
		button:SetWide(ScrW() * 0.2)
		button:SetButtonList(self.characterList.buttons)
		button.character = character
		button.OnSelected = function(panel)
			self:OnCharacterButtonSelected(panel)
		end
		button:SetHelixTooltip(function(tooltip)
			local name = tooltip:AddRow("name")
			name:SetImportant()
			name:SetText(character:GetName())
			name:SizeToContents()
			name:SetBackgroundColor(faction.color or color_white)

			local description = tooltip:AddRow("description")
			description:SetText(character:GetDescription())
			description:SizeToContents()
		end)

		button.PaintBackground = function(this, width, height)
			local alpha = this.selected and 255 or this.currentBackgroundAlpha

			surface.SetDrawColor(ColorAlpha(color_black, 66))
			surface.DrawRect(0, 0, width, height)
		
			surface.SetDrawColor(ColorAlpha(this.backgroundColor, alpha))
			surface.DrawOutlinedRect(0, 0, width, height, ScreenScale(1))
		end

		local model = button:Add("DModelPanel")
		model:Dock(FILL)
		model:DockMargin(0, 0, 0, 4)
		model:SetModel(character:GetModel())
		model:SetMouseInputEnabled(false)
		model:SetFOV(35)
		model.LayoutEntity = function(this, entity)
			this:DrawModel()
			this:RunAnimation()
			entity:SetAngles(Angle(0, 45, 0))
		end

		local entity = model:GetEntity()
		if (IsValid(entity)) then
			local sequence = entity:LookupSequence("idle_unarmed")
		
			if (sequence <= 0) then
				sequence = entity:SelectWeightedSequence(ACT_IDLE)
			end
		
			if (sequence > 0) then
				entity:ResetSequence(sequence)
			else
				local found = false
		
				for _, v in ipairs(entity:GetSequenceList()) do
					if ((v:lower():find("idle") or v:lower():find("fly")) and v != "idlenoise") then
						entity:ResetSequence(v)
						found = true
		
						break
					end
				end
		
				if (!found) then
					entity:ResetSequence(4)
				end
			end
		end

		-- select currently loaded character if available
		local localCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

		if (localCharacter and character:GetID() == localCharacter:GetID()) then
			button:SetSelected(true)
			self.characterList:ScrollToChild(button)

			bSelected = true
		end

		self.characterList:AddPanel(button)
	end

	if (!bSelected) then
		local buttons = self.characterList.buttons

		if (#buttons > 0) then
			local button = buttons[#buttons]

			button:SetSelected(true)
			self.characterList:ScrollToChild(button)
		else
			self.character = nil
		end
	end

	self.characterList:SizeToContents()
end

function PANEL:OnSlideUp()
	self.bActive = true
	self:Populate()
end

function PANEL:OnSlideDown()
	self.bActive = false
end

function PANEL:OnCharacterButtonSelected(panel)
	self.character = panel.character
end

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintCharacterLoadBackground", self, width, height)
end

vgui.Register("ixCharMenuLoad", PANEL, "ixCharMenuPanel")
