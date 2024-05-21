local PLUGIN = PLUGIN

util.AddNetworkString("ixScannerData")
util.AddNetworkString("ixScannerPicture")

net.Receive("ixScannerData", function(length, ply)
    if (IsValid(ply.ixScn) and ply:GetViewEntity() == ply.ixScn and (ply.ixNextPic or 0) < CurTime()) then
        local delay = 15
        ply.ixNextPic = CurTime() + delay - 1

        local length = net.ReadUInt(16)
        local data = net.ReadData(length)

        if (length != #data) then
            return
        end

        local receivers = {}

        for k, v in player.Iterator() do
            if not ( IsValid(v) ) then
                continue
            end

            if v:IsCombine() or v:IsDispatch() then
                receivers[#receivers + 1] = v
                ix.util.EmitQueuedSounds(v, {
                    "npc/metropolice/vo/on1.wav",
                    "npc/overwatch/radiovoice/preparevisualdownload.wav",
                    "npc/metropolice/vo/off1.wav"
                })
            end
        end

        if (#receivers > 0) then
            net.Start("ixScannerData")
                net.WriteUInt(#data, 16)
                net.WriteData(data, #data)
            net.Send(receivers)
        end
    end
end)

net.Receive("ixScannerPicture", function(length, ply)
    if (not IsValid(ply.ixScn)) then return end
    if (ply:GetViewEntity() ~= ply.ixScn) then return end
    if ((ply.ixNextFlash or 0) >= CurTime()) then return end

    ply.ixNextFlash = CurTime() + 1
    ply.ixScn:flash()

    for k, v in ipairs(ents.FindInSphere(ply.ixScn:GetPos(), 128)) do
        if not ( IsValid(v) ) then
            continue
        end

        if not ( v:IsPlayer() and v:Alive() ) then
            continue
        end

        if not ( v == ply ) then
            v:ScreenFade(1, Color(255, 255, 255), 5, 2)
            v:SetDSP(31)
            timer.Simple(4, function() v:SetDSP(1) end)
        end
    end
end)