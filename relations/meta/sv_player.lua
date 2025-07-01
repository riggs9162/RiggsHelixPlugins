local PLAYER = FindMetaTable("Player")

function PLAYER:UpdateRelations(ply)
    if ( !ix.config.Get("npcRelations", false) ) then return end

    for k, v in ents.Iterator() do
        if ( !IsValid(v) or !v:IsNPC() ) then continue end

        local faction = ply:GetCharacter():GetFaction()
        local relations = self.relations[faction]
        if ( !relations ) then continue end

        for k2, v2 in pairs(relations) do
            if ( !v2[v:GetClass()] ) then continue end

            local disposition = hook.Run("ModifyNPCDisposition", ply, v, k2)
            if ( disposition == nil ) then
                disposition = k2
            end

            v:AddEntityRelationship(ply, disposition, ix.config.Get("npcRelationsPriority", 0))
        end
    end
end