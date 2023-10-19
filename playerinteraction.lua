local PLUGIN = PLUGIN

PLUGIN.name = "Player Interaction"
PLUGIN.description = "Allows players to interact with each other."
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "HL2 RP"
PLUGIN.license = [[
Copyright 2023 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

--- you need lua knowledge to use this plugin
-- these are template functions that you can use to create your own
PLUGIN.interactions = {
    ["search"] = {
        name = "Search",
        description = "Search the tied character infront of you.",
        check = function(ply, target)
            if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() and target:IsRestricted() ) then return false end
            if ( ply:IsRestricted() ) then return false end
    
            return true
        end,
        action = function(ply, target)
            Schema:SearchPlayer(ply, target)
        end,
    },
    ["untie"] = {
        name = "Untie",
        description = "Untie the tied character infront of you.",
        check = function(ply, target)
            if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() and target:IsRestricted() ) then return end
            if ( target:GetNetVar("untying") ) then return end
            if ( ply:IsRestricted() ) then return end
    
            return true
        end,
        action = function(ply, target)
            target:SetRestricted(false)
            target:SetAction("You are being untied...", 5)
            target:SetNetVar("untying", true)
    
            ply:SetAction("Untying...", 5)
    
            ply:DoStaredAction(target, function()
                target:SetRestricted(false)
                target:SetNetVar("untying")
            end, 5, function()
                if ( IsValid(target) ) then
                    target:SetNetVar("untying")
                    target:SetAction()
                end
    
                if ( IsValid(ply) ) then
                    ply:SetAction()
                end
            end)
        end,
    },
    ["recognise"] = {
        name = "Recognise",
        description = "Recognise the player infront of you.",
        check = function(ply, target)
            if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then return end
    
            return true
        end,
        action = function(ply, target)
            target:GetCharacter():Recognize(ply:GetCharacter():GetID()) -- not sure if this actually works or not...
        end,
    },
}

if ( CLIENT ) then
    ix.gui.interactionMenu = nil
    function PLUGIN:Think()
        if ( input.IsKeyDown(KEY_F6) ) then
            if not ( ix.gui.interactionMenu ) then
                local trace = {}
                trace.start = LocalPlayer():EyePos()
                trace.endpos = trace.start + LocalPlayer():GetAimVector() * 96
                trace.filter = LocalPlayer()

                ix.gui.interactionMenu = vgui.Create("ixInteractionMenu")
                ix.gui.interactionMenu:SetTarget(util.TraceLine(trace).Entity)
            end
        end
    end

    local PANEL = {}

    function PANEL:Init()
        self:SetSize(ScrW() / 4, ScrH() / 4)
        self:MakePopup()
        self:Center()
        self:SetTitle("Interaction Menu")
        self:SetDraggable(false)
        self:ShowCloseButton(true)
        self:SetBackgroundBlur(true)

        self.target = nil

        self.list = vgui.Create("DScrollPanel", self)
        self.list:Dock(FILL)
        self.list:SetDrawBackground(false)
        self.list.VBar:SetWide(0)

        timer.Simple(0.1, function()
            for k, v in pairs(PLUGIN.interactions) do
                if ( v.check(LocalPlayer(), self.target) ) then
                    local button = vgui.Create("ixMenuButton", self.list)
                    button:Dock(TOP)
                    button:SetText(v.name)
                    button:SetToolTip(v.description)
                    button:SetTall(30)
                    button:SetFont("ixMenuButtonFontSmall")
                    button.DoClick = function()
                        net.Start("ixInteraction")
                            net.WriteString(k)
                            net.WriteEntity(self.target)
                        net.SendToServer()

                        self:Close()
                    end
                end
            end
        end)
    end

    function PANEL:SetTarget(target)
        self.target = target
    end

    function PANEL:OnClose()
        ix.gui.interactionMenu = nil
    end

    vgui.Register("ixInteractionMenu", PANEL, "DFrame")
else
    util.AddNetworkString("ixInteraction")

    net.Receive("ixInteraction", function(len, ply)
        local interaction = net.ReadString()
        local target = net.ReadEntity()

        if ( PLUGIN.interactions[interaction] and PLUGIN.interactions[interaction].check(ply, target) ) then
            PLUGIN.interactions[interaction].action(ply, target)
        end
    end)
end
