local PLAYER = FindMetaTable("Player")

util.AddNetworkString("ixPlaySound")
function PLAYER:PlaySound(sound, pitch)
    net.Start("ixPlaySound")
        net.WriteString(tostring(sound))
        net.WriteUInt(tonumber(pitch) or 100, 7)
    net.Send(self)
end

util.AddNetworkString("ixCreateVGUI")
function PLAYER:OpenVGUI(panel)
    if not isstring(panel) then
        ErrorNoHalt("Warning argument is required to be a string! Instead is "..type(panel).."\n")
        return
    end

    net.Start("ixCreateVGUI")
        net.WriteString(panel)
    net.Send(self)
end

concommand.Add("ix_stopsoundall", function(client, cmd, args)
    if ( client:IsSuperAdmin() ) then
        for k, v in player.Iterator() do
            v:ConCommand("stopsound")
        end
    else
        client:Notify("You must be a Super Admin to forcefully stopsound everyone!")
    end
end)

concommand.Add("ix_eventmenu", function(client, cmd, args)
    if ( client:IsSuperAdmin() ) then
        client:OpenVGUI("ixEventMenu")
    else
        client:Notify("You must be a Super Admin to have access to the event manager menu!")
    end
end)

util.AddNetworkString("ixPlaySoundAll")
net.Receive("ixPlaySoundAll", function(len, client)
    if not ( client:IsSuperAdmin() ) then return end

    local stringSound = Sound(net.ReadString())
    for k, v in player.Iterator() do
        v:PlaySound(stringSound)
    end
end)
