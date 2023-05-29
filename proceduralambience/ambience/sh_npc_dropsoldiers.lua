AMBIENCE.name = "Dropship Soldiers"
AMBIENCE.description = "Dropship Soldiers"
AMBIENCE.map = "rp_city17_build210"

AMBIENCE.startPos = Vector(-682.03753662109, 1767.365234375, 1082.0084228516)
AMBIENCE.startAng = Angle(15.444039344788, -88.911323547363, 0)

AMBIENCE.onPlay = function(ambienceTable)
    local dropship = ents.Create("npc_combinedropship")
    dropship:SetPos(ambienceTable.startPos)
    dropship:SetAngles(ambienceTable.startAng)
    dropship:SetKeyValue("squadname", "overwatch")
    dropship:SetKeyValue("GunRange", "3000")
    dropship:SetKeyValue("CrateType", "1")
    dropship:CapabilitiesAdd(CAP_MOVE_FLY)
    dropship:CapabilitiesAdd(CAP_SQUAD)
    dropship:Spawn()
    dropship:Activate()

    local dropflyingpoint = ents.Create("path_track")
    dropflyingpoint:SetName("dropship_track_1")
    dropflyingpoint:SetPos(Vector(-512.12084960938, -386.68762207031, 641.89007568359))
    dropflyingpoint:Spawn()
    dropship:Fire("SetTrack", "dropship_track_1")

    local dropposition = ents.Create("scripted_target")
    dropposition:SetPos(Vector(-483.25915527344, -11.943428993225, 76.03125))
    dropposition:SetNotSolid(true)
    dropposition:SetNoDraw(true)
    dropposition:Spawn()
    dropposition:Activate()
    dropposition:SetName("dropship_landing_point")

    timer.Simple(3, function()
        dropship:Fire("SetLandTarget", "dropship_landing_point")
        dropship:Fire("StopWaitingForDropoff")
        dropship:Fire("LandTakeCrate", 0)
    end)
end

AMBIENCE_NPC_DROPSHIP = AMBIENCE.index

print("[AMBIENCE] "..AMBIENCE.name.." loaded.")