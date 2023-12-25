local PLUGIN = PLUGIN

function PLUGIN:HelpMenuScroller(key)
    if ( key == "achievements" ) then
        return true
    end
end

function PLUGIN:PopulateHelpMenu(tabs)
    local ply = LocalPlayer()
    local char = ply:GetCharacter()

    tabs["achievements"] = function(container)
        for k, v in ipairs(ix.achievements.stored) do
            local bCompleted = ix.achievements.Completed(char, v.name)

            local panel = container:Add("DPanel")
            panel:SetTall(ScreenScale(12) * 3)
            panel:Dock(TOP)
            panel:DockMargin(0, 0, 0, 8)
            panel.Paint = function(self, width, height)
                surface.SetDrawColor(0, 0, 0, 66)
                surface.DrawRect(0, 0, width, height)
            end

            local material = Material(v.icon)
            local padding = ScreenScale(4)
            local icon = panel:Add("DPanel")
            icon:Dock(LEFT)
            icon:DockMargin(0, 0, 8, 0)
            icon:SetSize(panel:GetTall(), panel:GetTall())
            icon.Paint = function(self, width, height)
                surface.SetDrawColor(color_white)
                surface.SetMaterial(material)
                surface.DrawTexturedRect(padding, padding, width - padding * 2, height - padding * 2)
            end

            local label = panel:Add("DLabel")
            label:Dock(TOP)
            label:DockMargin(0, 0, 0, 0)
            label:SetText(v.name)
            label:SetFont("ixMenuButtonFont")
            label:SetContentAlignment(4)
            label:SetWrap(true)
            label:SetAutoStretchVertical(true)

            label = panel:Add("DLabel")
            label:Dock(TOP)
            label:DockMargin(0, 0, 0, 0)
            label:SetText(v.description)
            label:SetFont("ixMenuButtonFontSmall")
            label:SetContentAlignment(4)
            label:SetWrap(true)
            label:SetAutoStretchVertical(true)

            label = panel:Add("DLabel")
            label:Dock(TOP)
            label:DockMargin(0, 0, 0, 0)
            label:SetText(bCompleted and "Completed" or "Incomplete")
            label:SetTextColor(bCompleted and Color(0, 255, 0) or Color(255, 0, 0))
            label:SetFont("ixMenuButtonFontSmall")
            label:SetContentAlignment(4)
            label:SetWrap(true)
            label:SetAutoStretchVertical(true)
        end
    end
end
