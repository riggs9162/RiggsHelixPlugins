local PANEL = {}

function PANEL:Init()
    ix.gui.f4menu = self

    self.subCategories = {}
    self.padding = ScreenScale(16)

    self:SetSize(ScrW(), ScrH())
    self:DockPadding(self.padding, self.padding, self.padding, self.padding)
    self:MakePopup()

    self.categories = self:Add("DHorizontalScroller")
    self.categories:Dock(TOP)
    self.categories:SetTall(self.padding)

    self.rightPanel = self:Add("EditablePanel")
    self.rightPanel:Dock(RIGHT)
    self.rightPanel:SetWide(self:GetWide() * 0.25)

    local button = self.rightPanel:Add("ixMenuButton")
    button:Dock(BOTTOM)
    button:SetText("f4MenuExit")
    button:SetContentAlignment(5)
    button:SizeToContents()
    button.DoClick = function(this)
        self:Remove()
    end

    button = self.rightPanel:Add("ixMenuButton")
    button:Dock(BOTTOM)
    button:SetText("f4MenuBecome")
    button:SetContentAlignment(5)
    button:SizeToContents()
    button.DoClick = function(this)
        if not ( self.faction and self.class ) then
            return
        end

        net.Start("ixFactionPanelSwitch")
            net.WriteUInt(self.faction, 8)
            net.WriteUInt(self.class, 8)
        net.SendToServer()
    end

    for k, v in ipairs(ix.faction.indices) do
        if ( k == FACTION_UNASSIGNED ) then
            continue
        end

        button = self.categories:Add("ixMenuButton")
        button.padding = {12, 12, 12, 12} // left, top, right, bottom
        button:Dock(LEFT)
        button:SetText(v.name)
        button:SetBackgroundColor(v.color)
        button:SetContentAlignment(5)
        button:SizeToContents()
        button.DoClick = function(this)
            self.faction = k
            self:PopulateCategories()
        end
    end
end

function PANEL:PopulateCategories()
    if ( IsValid(self.factionCategories) ) then
        self.factionCategories:Remove()
    end

    if ( IsValid(self.classes) ) then
        self.classes:Remove()
    end

    self.factionCategories = self:Add("DHorizontalScroller")
    self.factionCategories:Dock(TOP)
    self.factionCategories:DockMargin(0, 0, 0, self.padding)
    self.factionCategories:SetTall(self.padding * 0.75)

    self.subCategories = {}

    for k, v in ipairs(ix.class.list) do
        if ( v.faction != self.faction ) then
            continue
        end

        if ( v.category ) then
            if ( self.subCategories[v.category] ) then
                continue
            end

            self.subCategories[v.category] = true

            if ( #self.subCategories == 1 ) then
                self:PopulateClasses()
                break
            end

            button = self.factionCategories:Add("ixMenuButton")
            button.padding = {12, 12, 12, 12} // left, top, right, bottom
            button:Dock(LEFT)
            button:SetText(v.category)
            button:SetFont("ixMenuButtonFontSmall")
            button:SetContentAlignment(5)
            button:SizeToContents()
            button.DoClick = function(this)
                self:PopulateClasses(v.category)
            end
        else
            self:PopulateClasses()
            break
        end
    end
end

function PANEL:PopulateClasses(category)
    if ( IsValid(self.classes) ) then
        self.classes:Remove()
    end

    self.classes = self:Add("DScrollPanel")
    self.classes:Dock(LEFT)
    self.classes:SetWide(self:GetWide() * 0.35)

    for k, v in ipairs(ix.class.list) do
        if ( v.faction != self.faction ) then
            continue
        end

        if ( category and v.category != category ) then
            continue
        end

        button = self.classes:Add("ixMenuButton")
        button:Dock(TOP)
        button:SetText(v.name)
        button:SetTextInset(self.padding * 2 + 8, 0)
        button:SetContentAlignment(4)
        button:SetTall(self.padding * 2)
        button.DoClick = function(this)
            self.class = k
        end

        local model = button:Add("ixSpawnIcon")
        model:Dock(LEFT)
        model:SetWide(button:GetTall())
        model:SetModel(LocalPlayer():GetModel()) // TODO: change this
    end
end

local gradient = Material("vgui/gradient-d")
local gradientUp = Material("vgui/gradient-u")
function PANEL:Paint(width, height)
    ix.util.DrawBlur(self)

    surface.SetDrawColor(ColorAlpha(color_black, 200))
    surface.DrawRect(0, 0, width, height)

    surface.SetDrawColor(ix.config.Get("color"))
    surface.SetMaterial(gradientUp)
    surface.DrawTexturedRect(0, -height * 0.5, width, height)

    surface.SetDrawColor(color_black)
    surface.SetMaterial(gradient)
    surface.DrawTexturedRect(0, 0, width, height)
end

vgui.Register("ixF4Menu", PANEL, "EditablePanel")

if ( IsValid(ix.gui.f4menu) ) then
    ix.gui.f4menu:Remove()
end