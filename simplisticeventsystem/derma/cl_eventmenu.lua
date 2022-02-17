local PLUGIN = PLUGIN

local fileLimit = 2500
local formats = {".wav", ".ogg", ".mp3", ".midi"}

local function PaintPanel(self, w, h)
    surface.SetDrawColor(Color(20, 20, 20, 200))
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(ix.config.Get("color"))
    surface.DrawOutlinedRect(0, 0, w, h)
end

local function CreateCatergory(self, text)
    self.catergory = self:Add("DPanel")
    self.catergory:Dock(TOP)
    self.catergory:DockMargin(5, 5, 5, 5)
    self.catergory:SetSize(0, 40)
    self.catergory.Paint = function(self, w, h)
        ix.util.DrawBlur(self, 2)

        surface.SetDrawColor(ColorAlpha(ix.config.Get("color"), 20))
        surface.DrawRect(0, 0, w, h)

        draw.DrawText(text, "RiggsFontShadow30", w / 2, h / 2 - 15, ix.config.Get("color"), TEXT_ALIGN_CENTER)
    end
end

local function CreateMusicButtons(self, type)
    for k, v in pairs(type) do
        if not ( v[1] == "" or v[2] == "" ) then
            self.musicbutton = self:Add("ixMenuButton")
            self.musicbutton:Dock(TOP)
            self.musicbutton:SetText(v[1].."  |  "..v[2])

            self.musicbutton:SetFont("RiggsFont18")
            self.musicbutton:SetSize(0, 20)
            self.musicbutton:SetContentAlignment(5)
            self.musicbutton:DockMargin(5, 0, 5, 0)
            self.musicbutton.DoClick = function()
                RunConsoleCommand("ix_stopsoundall")
                timer.Simple(0.1, function()
                    net.Start("ixPlaySoundAll")
                        net.WriteString(v[2])
                    net.SendToServer()
                end)
                ix.util.Notify("Played "..v[1].." ("..v[2]..") to all players!")
            end

            self.musicbutton.DoRightClick = function()
                RunConsoleCommand("stopsound")
                timer.Simple(0.1, function()
                    LocalPlayer():EmitSound(v[2], 40)
                end)
                ix.util.Notify("You played "..v[1].." ("..v[2]..") only to yourself!")
            end
        end
    end
end

local PANEL = {}

function PANEL:Init()
    self:SetSize(1500, 900)
    self:SetTitle("")
    self:Center()
    self:MakePopup()

    self.sheet = self:Add("DColumnSheet")
    self.sheet:Dock(FILL)
    self.sheet:DockMargin(5, 5, 5, 5)

    self.musicpanel = self.sheet:Add("DPanel")
    self.musicpanel:Dock(FILL)
    self.musicpanel:DockMargin(10, 10, 10, 10)
    self.musicpanel.Paint = function(self, w, h)
        PaintPanel(self, w, h)
    end

    self.musicplayer = self.musicpanel:Add("DScrollPanel")
    self.musicplayer:SetSize(0, 700)
    self.musicplayer:Dock(TOP)

    for k, v in pairs(ix.adminSystem.music) do
        CreateCatergory(self.musicplayer, k)
        CreateMusicButtons(self.musicplayer, ix.adminSystem.music[k])
    end

    self.musiccontrol = self.musicpanel:Add("DScrollPanel")
    self.musiccontrol:Dock(FILL)
    self.musiccontrol.Paint = function(self, w, h)
        PaintPanel(self, w, h)
    end
    
    self.stopsound = self.musiccontrol:Add("ixMenuButton")
    self.stopsound:Dock(TOP)
    self.stopsound:SetSize(0, 30)
    self.stopsound:SetText("Stop Sound")
    self.stopsound:SetFont("RiggsFont28")
    self.stopsound.DoClick = function()
        RunConsoleCommand("stopsound")
    end
    
    self.stopsoundall = self.musiccontrol:Add("ixMenuButton")
    self.stopsoundall:Dock(TOP)
    self.stopsoundall:SetSize(0, 30)
    self.stopsoundall:SetText("Stop Sound All")
    self.stopsoundall:SetFont("RiggsFont28")
    self.stopsoundall.DoClick = function()
        RunConsoleCommand("ix_stopsoundall")
    end

    self.sheet:AddSheet("Music Player", self.musicpanel)

    hook.Add("Think", "ixEventMenuPressedSpace", function()
        if input.IsKeyDown(KEY_SPACE) and !keyDown then
            self.playsound.DoClick()
            keyDown = true
            timer.Simple(0.4, function() keyDown = false end)
        end
    end)

    self.soundplayer = self.sheet:Add("DScrollPanel")
    self.soundplayer:Dock(FILL)
    self.soundplayer:DockMargin(10, 10, 10, 10)

    self.soundtree = self.soundplayer:Add("DTree")
    self.soundtree:Dock(TOP)
    self.soundtree:SetSize(0, 600)
    self.soundtree.Paint = function(self, w, h)
        PaintPanel(self, w, h)
    end
    
    self.playsound = self.soundplayer:Add("ixMenuButton")
    self.playsound:Dock(TOP)
    self.playsound:SetSize(0, 30)
    self.playsound:SetText("Play Sound")
    self.playsound:SetFont("ixSmallFont")
    
    self.stopsound = self.soundplayer:Add("ixMenuButton")
    self.stopsound:Dock(TOP)
    self.stopsound:SetSize(0, 30)
    self.stopsound:SetText("Stop Sound")
    self.stopsound:SetFont("ixSmallFont")
    
    self.copyfile = self.soundplayer:Add("ixMenuButton")
    self.copyfile:Dock(TOP)
    self.copyfile:SetSize(0, 30)
    self.copyfile:SetText("Copy Filepath")
    self.copyfile:SetFont("ixSmallFont")
    
    self.refreshlist = self.soundplayer:Add("ixMenuButton")
    self.refreshlist:Dock(TOP)
    self.refreshlist:SetSize(0, 30)
    self.refreshlist:SetText("Refresh List")
    self.refreshlist:SetFont("ixSmallFont")
    
    self.playtoall = self.soundplayer:Add("ixMenuButton")
    self.playtoall:Dock(TOP)
    self.playtoall:SetSize(0, 30)
    self.playtoall:SetText("Play to all")
    self.playtoall:SetFont("ixSmallFont")
    
    self.stopsoundall = self.soundplayer:Add("ixMenuButton")
    self.stopsoundall:Dock(TOP)
    self.stopsoundall:SetSize(0, 30)
    self.stopsoundall:SetText("Stop Sound all")
    self.stopsoundall:SetFont("ixSmallFont")

    self.soundtreenode = self.soundtree:AddNode("sound")
    self.soundtreenode.dir  = "sound/"
    self.soundtreenode.gen = false
    
    local function FindSounds(node, dir)
        local files, dirs = file.Find(dir.."*", "GAME")
    
        for _, v in pairs(dirs) do
            local newNode = node:AddNode(v)
            newNode.dir = dir..v
            newNode.gen = false
        
            newNode.DoClick = function()
                if !newNode.gen then
                    FindSounds(newNode, dir..v.."/")
                    newNode.gen = true
                end
            end
        end

        local function GenerateNodes()
            local fileCount = 0

            for k, v in pairs(files) do
                if fileCount > fileLimit then break end
                local format = string.sub(v, -4)
                if format and table.HasValue(formats, format) then
                    fileCount = fileCount + 1

                    local newNode = node:AddNode(v)
                    newNode.file   = v
                    newNode.dir    = dir
                    newNode.IsFile = true
                    newNode.format = format
                    newNode.Icon:SetImage("icon16/sound.png")

                    files[k] = ""
                end
            end
        
            if fileCount > fileLimit then
                local newNode = node:AddNode("Click to load more files...")
                newNode.Icon:SetImage("icon16/sound_add.png")
                newNode.DoClick = function() 
                    newNode:Remove()
                    GenerateNodes()
                end
            end
        end
        GenerateNodes()
    end
    FindSounds(self.soundtreenode, "sound/")

    self.playsound.DoClick = function()
        local item = self.soundtree:GetSelectedItem()
        if !item or !item.IsFile then return end
        local file = string.sub(item.dir, 7)..item:GetText()
        surface.PlaySound(file)
    end

    self.stopsound.DoClick = function()
        RunConsoleCommand("stopsound")
    end

    self.copyfile.DoClick = function()
        local item = self.soundtree:GetSelectedItem()
        if !item or !item.IsFile then return end
        local file = string.sub(item.dir, 7)..item:GetText()
        SetClipboardText(file)
    end

    self.refreshlist.DoClick = function()
        self.soundtreenode:Remove()
        self.soundtreenode = self.soundtree:AddNode("sound")
        self.soundtreenode.dir  = "sound/"
        self.soundtreenode.gen = false
    
        FindSounds(self.soundtreenode, "sound/")
    end

    self.playtoall.DoClick = function()
        local item = self.soundtree:GetSelectedItem()
        if !item or !item.IsFile then return end
        local file = string.sub(item.dir, 7)..item:GetText()
        timer.Simple(0.1, function()
            net.Start("ixPlaySoundAll")
                net.WriteString(file)
            net.SendToServer()
        end)
        ix.util.Notify("Played "..tostring(file).." to all players!")
    end

    self.stopsoundall.DoClick = function()
        RunConsoleCommand("ix_stopsoundall")
    end

    self.sheet:AddSheet("Sound Player", self.soundplayer)

    self.OnClose = function()
        hook.Remove("Think", "ixEventMenuPressedSpace")
    end 
end

vgui.Register("ixEventMenu", PANEL, "DFrame")