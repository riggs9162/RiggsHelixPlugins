local PLUGIN = PLUGIN

local bPressed = false
function PLUGIN:Think()
    if ( LocalPlayer():GetCharacter() and not IsValid(ix.gui.menu)) and ( input.IsKeyDown(KEY_F1) and !bPressed ) then
        local ixMenu = vgui.Create("ixMenu")

        bPressed = true

        function ixMenu:OnKeyCodePressed(key)
            self.noAnchor = CurTime() + 0.5
        
            if ( key == KEY_F1 ) then
                self:Remove()

                timer.Simple(0.5, function()
                    bPressed = false
                end)
            end
        end

        function ixMenu:Think()
            if ( IsValid(self.projectedTexture) ) then
                local forward = LocalPlayer():GetForward()
                forward.z = 0

                local right = LocalPlayer():GetRight()
                right.z = 0

                self.projectedTexture:SetBrightness(self.overviewFraction * 4)
                self.projectedTexture:SetPos(LocalPlayer():GetPos() + right * 16 - forward * 8 + self.projectedTexturePosition)
                self.projectedTexture:SetAngles(forward:Angle() + self.projectedTextureRotation)
                self.projectedTexture:Update()
            end

            if ( self.bClosing ) then
                return
            end

            local bTabDown = input.IsKeyDown(KEY_F1)

            if ( bTabDown and ( self.noAnchor or CurTime() + 0.4 ) < CurTime() and self.anchorMode ) then
                self.anchorMode = false
                surface.PlaySound("buttons/lightswitch2.wav")
            end

            if ( ( !self.anchorMode and !bTabDown ) or gui.IsGameUIVisible() ) then
                self:Remove()

                bPressed = false
            end
        end
    end
end