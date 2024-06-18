AMBIENCE.name = "NPC Helicopter"
AMBIENCE.description = "Creates a helicopter in the map that flies towards a certain position."
AMBIENCE.map = "rp_city17_build210"

AMBIENCE.startAng = Angle(0.93962049484253, -128.33221435547, 0)
AMBIENCE.startPos = Vector(2104.5307617188, 3256.3034667969, 496.61492919922)
AMBIENCE.endPos = Vector(-1420.5029296875, -1248.3472900391, 570.54107666016)

AMBIENCE.onPlay = function(ambienceTable)
    local heli = ents.Create("npc_helicopter")
    heli:SetPos(ambienceTable.startPos)
    heli:SetAngles(ambienceTable.startAng)
    heli:Spawn()

    for k, v in player.Iterator() do
        heli:AddEntityRelationship(v, D_FR, 0)
    end

    local helitrack = ents.Create("path_track")
    helitrack:SetName(heli:EntIndex().."-Track5555")
    helitrack:SetPos(ambienceTable.endPos)

    heli:Fire("flytospecifictrackviapath", heli:EntIndex().."-Track5555")

    hook.Add("Think", "NPCHeliThink", function()
        if ( heli:GetPos():Distance(ambienceTable.endPos) < 100 ) then
            heli:Input("Kill")
            hook.Remove("Think", "NPCHeliThink")
        end
    end)
end

AMBIENCE_NPC_HELI = AMBIENCE.index

print("[AMBIENCE] "..AMBIENCE.name.." loaded.")