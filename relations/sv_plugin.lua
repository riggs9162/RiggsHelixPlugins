local PLUGIN = PLUGIN

function PLUGIN:UpdateRelations(ply)
    for k, v in ents.Iterator() do
        if not ( IsValid(v) and v:IsNPC() ) then
            continue
        end

        local faction = ply:GetCharacter():GetFaction()
        local relations = self.relations[faction]
        if not ( relations ) then
            continue
        end

        for k2, v2 in pairs(relations) do
            if not ( v2[v:GetClass()] ) then
                continue
            end

            v:AddEntityRelationship(ply, k2, 99)

            hook.Run("OnSetRelationship", ply, v, k2)
        end
    end
end