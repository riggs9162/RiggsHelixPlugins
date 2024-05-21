local PLUGIN = PLUGIN

function PLUGIN:OnNPCKilled(ent, ply)
    local config = self.config[ent:GetClass()]

    if not ( config and config.items ) then
        return
    end

    local randomChance = math.random(1, 100)
    if not ( randomChance >= config.rarity ) then
        return
    end

    if ( config.randomItems ) then
        ix.item.Spawn(config.items[math.random(1, #config.items)], ent:GetPos() + Vector(0, 0, 16), nil, ent:GetAngles())
    else
        for k, v in ipairs(config.items) do
            ix.item.Spawn(v, ent:GetPos() + Vector(0, 0, 16), nil, ent:GetAngles())
        end
    end
end