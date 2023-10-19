local PLUGIN = PLUGIN

ix.command.Add("GetXPos", {
    description = "Get's your current X position and copies it.",
    adminOnly = true,
    OnRun = function(self, ply)
        ix.util.Notify("Copied to Clipboard!")
    
        local pos = LocalPlayer():GetPos()
        SetClipboardText(pos.x)
    end,
})

ix.command.Add("GetYPos", {
    description = "Get's your current Y position and copies it.",
    adminOnly = true,
    OnRun = function(self, ply)
        ix.util.Notify("Copied to Clipboard!")
    
        local pos = LocalPlayer():GetPos()
        SetClipboardText(pos.y)
    end,
})

ix.command.Add("GetZPos", {
    description = "Get's your current Z position and copies it.",
    adminOnly = true,
    OnRun = function(self, ply)
        ix.util.Notify("Copied to Clipboard!")
    
        local pos = LocalPlayer():GetPos()
        SetClipboardText(pos.z)
    end,
})

net.Receive("ixShopTerminal.Open", function()
    vgui.Create("ixShopTerminal")
end)