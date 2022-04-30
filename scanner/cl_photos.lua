local PLUGIN = PLUGIN

local PICTURE_WIDTH = PLUGIN.PICTURE_WIDTH
local PICTURE_HEIGHT = PLUGIN.PICTURE_HEIGHT
local PICTURE_WIDTH2 = PICTURE_WIDTH * 0.5
local PICTURE_HEIGHT2 = PICTURE_HEIGHT * 0.5

PHOTO_CACHE = PHOTO_CACHE or {}

function PLUGIN:takePicture()
    if ((self.lastPic or 0) < CurTime()) then
        self.lastPic = CurTime() + 15

        net.Start("ixScannerPicture")
        net.SendToServer()

        timer.Simple(0.1, function()
            self.startPicture = true
        end)
    end
end

function PLUGIN:PostRender()
    if (self.startPicture) then
        local data = util.Compress(render.Capture({
            format = "jpeg",
            h = PICTURE_HEIGHT,
            w = PICTURE_WIDTH,
            quality = 35,
            x = ScrW() * 0.5 - PICTURE_WIDTH2,
            y = ScrH() * 0.5 - PICTURE_HEIGHT2
        }))

        net.Start("ixScannerData")
            net.WriteUInt(#data, 16)
            net.WriteData(data, #data)
        net.SendToServer()
        
        self.startPicture = false
    end
end

net.Receive("ixScannerData", function()
    local data = net.ReadData(net.ReadUInt(16))
    data = util.Base64Encode(util.Decompress(data))

    if (not data) then return end

    if (IsValid(CURRENT_PHOTO)) then
        local panel = CURRENT_PHOTO

        CURRENT_PHOTO:AlphaTo(0, 0.25, 0, function()
            if (IsValid(panel)) then
                panel:Remove()
            end
        end)
    end

    local html = Format([[
        <html>
            <body style="background: black; overflow: hidden; margin: 0; padding: 0;">
                <img src="data:image/jpeg;base64,%s" width="%s" height="%s" />
            </body>
        </html>
    ]], data, PICTURE_WIDTH, PICTURE_HEIGHT)

    local panel = vgui.Create("DPanel")
    panel:SetSize(PICTURE_WIDTH + 8, PICTURE_HEIGHT + 8)
    panel:SetPos(ScrW(), 8)
    panel:SetDrawBackground(true)
    panel:SetAlpha(150)

    panel.body = panel:Add("DHTML")
    panel.body:Dock(FILL)
    panel.body:DockMargin(4, 4, 4, 4)
    panel.body:SetHTML(html)

    panel:MoveTo(ScrW() - (panel:GetWide() + 8), 8, 0.5)

    timer.Simple(15, function()
        if (IsValid(panel)) then
            panel:MoveTo(ScrW(), 8, 0.5, 0, -1, function()
                panel:Remove()
            end)
        end
    end)

    PHOTO_CACHE[#PHOTO_CACHE + 1] = {data = html, time = os.time()}
    CURRENT_PHOTO = panel
end)

concommand.Add("ix_scanner_photocache", function(ply)
    if ply:IsCombine() then
        local frame = vgui.Create("DFrame")
        frame:SetTitle("Photo Cache")
        frame:SetSize(480, 360)
        frame:MakePopup()
        frame:Center()

        frame.list = frame:Add("DScrollPanel")
        frame.list:Dock(FILL)
        frame.list:SetDrawBackground(true)

        for k, v in ipairs(PHOTO_CACHE) do
            local button = frame.list:Add("DButton")
            button:SetTall(28)
            button:Dock(TOP)
            button:DockMargin(4, 4, 4, 0)
            button:SetText(os.date("%X - %d/%m/%Y", v.time))
            button.DoClick = function()
                local frame2 = vgui.Create("DFrame")
                frame2:SetSize(PICTURE_WIDTH + 8, PICTURE_HEIGHT + 8)
                frame2:SetTitle(button:GetText())
                frame2:MakePopup()
                frame2:Center()

                frame2.body = frame2:Add("DHTML")
                frame2.body:SetHTML(v.data)
                frame2.body:Dock(FILL)
                frame2.body:DockMargin(4, 4, 4, 4)
            end
        end
    else
        ply:Notify("Only Combine Players can view the scanner photo cache!")
        return false
    end
end)