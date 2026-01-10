local PLAYER = FindMetaTable("Player")

function PLAYER:GetXP()
    return self:GetLocalVar("xp", 0)
end
