local PLUGIN = PLUGIN

function PLUGIN:PostPlayerLoadout(ply)
    if not ( ply:GetCharacter() ) then return end

    self:UpdateRelations(ply)
end

function PLUGIN:OnEntityCreated(entity)
    timer.Simple(0, function()
        if ( IsValid(entity) and entity:IsNPC() ) then
            for k, v in player.Iterator() do
                if not ( IsValid(v) ) then continue end
                if not ( v:Alive() ) then continue end
                if not ( v:GetCharacter() ) then continue end

                self:UpdateRelations(v)
            end
        end
    end)
end