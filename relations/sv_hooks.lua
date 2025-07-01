local PLUGIN = PLUGIN

function PLUGIN:PostPlayerLoadout(ply)
    if ( !ply:GetCharacter() ) then return end

    ply:UpdateRelations()
end

function PLUGIN:OnEntityCreated(entity)
    timer.Simple(0, function()
        if ( !IsValid(entity) or !entity:IsNPC() ) then return end

        for k, v in player.Iterator() do
            if ( !IsValid(v) or !v:Alive() or !v:GetCharacter() ) then continue end
            v:UpdateRelations()
        end
    end)
end

function PLUGIN:ModifyNPCDisposition(ply, ent, relationship)
    if ( !IsValid(ent) and ent:IsNPC() ) then return end

    local faction = ply:GetCharacter():GetFaction()
    local relations = self.relations[faction]
    if ( !relations ) then return end

    if ( ply:IsCombine() ) then
        local find = string.find
        local class = ent:GetClass()
        local model = ent:GetModel()

        if ( class == "npc_citizen" and ( find(model, "group02") or find(model, "group03") ) ) then
            ent:AddEntityRelationship(ply, D_HT, ix.config.Get("npcRelationsPriority", 0))
            return
        end

        if ( class == "npc_vortigaunt" and !find(model, "slave") ) then
            ent:AddEntityRelationship(ply, D_HT, ix.config.Get("npcRelationsPriority", 0))
            return
        end
    end
end