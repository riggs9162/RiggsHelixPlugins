local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW() / 2.5, ScrH() / 2)
    self:Center()
    self:MakePopup()

    self:SetTitle(" ")
    self:ShowCloseButton(false)

    self.selectedItem = nil
    self.selectedItems = {}

    local title = self:Add("ixLabel")
    title:SetPos(4, 2)
    title:SetText("Shop Terminal")
    title:SetFont("ixMediumFont")
    title:SizeToContents()

    local items = self:Add("DScrollPanel")
    items:Dock(LEFT)
    items:SetWide(self:GetWide() / 2.5)

    local info = self:Add("EditablePanel")
    info:Dock(FILL)

    local close = info:Add("ixMenuButton")
    close:Dock(BOTTOM)
    close:SetTall(ScreenScale(10))
    close:SetText("close")
    close.DoClick = function(this)
        self:Close()
    end

    local add = info:Add("ixMenuButton")
    add:Dock(BOTTOM)
    add:SetTall(ScreenScale(10))
    add:SetText("add to cart")
    add:SetEnabled(false)

    local clear = info:Add("ixMenuButton")
    clear:Dock(BOTTOM)
    clear:SetTall(ScreenScale(10))
    clear:SetText("clear cart")
    clear:SetEnabled(false)

    local checkout = info:Add("ixMenuButton")
    checkout:Dock(BOTTOM)
    checkout:SetTall(ScreenScale(10))
    checkout:SetText("go to checkout")
    checkout:SetEnabled(false)

    local itemIcon = info:Add("ixSpawnIcon")
    itemIcon:SetPos(0, 0)
    itemIcon:SetSize(ScreenScale(32), ScreenScale(32))

    local itemName = info:Add("ixLabel")
    itemName:SetPos(ScreenScale(32), 0)
    itemName:SetText("")
    itemName:SetFont("ixMediumLightFont")
    itemName:SizeToContents()

    local itemPrice = info:Add("ixLabel")
    itemPrice:SetPos(ScreenScale(32), ScreenScale(12))
    itemPrice:SetText("")
    itemPrice:SetFont("ixMediumLightFont")
    itemPrice:SizeToContents()

    local itemDescription = info:Add("RichText")
    itemDescription:Dock(TOP)
    itemDescription:DockMargin(0, ScreenScale(32), 0, 0)
    itemDescription:SetTall(ScreenScale(64))
    itemDescription:SetText("")
    itemDescription:SetVerticalScrollbarEnabled(false)

    for k, v in pairs(ix.item.list) do
        if not ( v.shopTerminalBuyable ) then
            continue
        end

        local item = items:Add("ixMenuButton")
        item:Dock(TOP)
        item:SetTall(ScreenScale(10))
        item:SetText("    "..v.name)
        item:SetToolTip(v.description)

        local icon = item:Add("ixSpawnIcon")
        icon:Dock(LEFT)
        icon:SetWide(ScreenScale(10))
        icon:SetModel(v.model or "models/error.mdl")
        icon:SetSkin(v.skin or 0)

        item.DoClick = function(this)
            itemIcon:SetModel(icon:GetModel())

            itemName:SetText(v.name)
            itemName:SizeToContents()

            itemPrice:SetText(v.price or "FREE")
            itemPrice:SizeToContents()

            itemDescription:SetText(v.description or "")
            itemDescription:SetFontInternal("ixMediumLightFont")

            self.selectedItem = v.uniqueID

            add:SetEnabled(true)
        end
    end

    local amount = 0
    add.DoClick = function(this)
        if not ( self.selectedItem ) then
            ix.util.Notify("You have nothing selected!")
            return
        end

        amount = amount + 1
        self.selectedItems[self.selectedItem] = amount
        this:SetText("add to cart ("..amount..")")

        clear:SetEnabled(true)
        checkout:SetEnabled(true)
    end

    clear.DoClick = function(this)
        if ( table.IsEmpty(self.selectedItems) ) then
            ix.util.Notify("You have nothing in your cart to clear!")
            return
        end

        amount = 0
        self.selectedItems = {}

        add:SetText("add to cart")
        this:SetEnabled(false)
        checkout:SetEnabled(false)
    end

    checkout.DoClick = function(this)
        if ( table.IsEmpty(self.selectedItems) ) then
            ix.util.Notify("You have nothing in your cart!")
            return
        end

        Derma_Query("Are you Sure?", "Shop Terminal", "Yes", function()
            net.Start("ixShopTerminal.Checkout")
                net.WriteUInt(table.Count(self.selectedItems), 8)
        
                for k, v in pairs(self.selectedItems) do
                    net.WriteString(k)
                    net.WriteUInt(v, 8)
                end    
            net.SendToServer()
        end, "No")
    end
end

function PANEL:Close()
    self:Remove()
    net.Start("ixShopTerminal.Close")
    net.SendToServer()
end

function PANEL:Think()
    local ply = LocalPlayer()

    if not ( IsValid(ply) and IsValid(ply:GetEyeTrace().Entity) and ply:GetEyeTrace().Entity:GetClass() == "ix_shopterminal" ) then
        self:Close()
    end
end

vgui.Register("ixShopTerminal", PANEL, "DFrame")