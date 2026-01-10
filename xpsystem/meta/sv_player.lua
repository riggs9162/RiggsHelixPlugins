local PLAYER = FindMetaTable("Player")

function PLAYER:SetXP(value)
    if ( !tonumber(value) ) then return end
    if ( tonumber(value) < 0 ) then return end

    self:SetLocalVar("xp", tonumber(value))
end

function PLAYER:AddXP(amount)
    if ( !tonumber(amount) ) then return end
    if ( tonumber(amount) <= 0 ) then return end

    local currentXP = self:GetXP()
    self:SetLocalVar("xp", currentXP + tonumber(amount))
end

function PLAYER:TakeXP(amount)
    if ( !tonumber(amount) ) then return end
    if ( tonumber(amount) <= 0 ) then return end

    local currentXP = self:GetXP()
    local newXP = math.max(0, currentXP - tonumber(amount))
    self:SetLocalVar("xp", newXP)
end

function PLAYER:GainXP()
    local amount = hook.Run("GetXPGainAmount", self)

    self:AddXP(amount)
    self:Notify("For playing on our server for 10 minutes, you have gained " .. amount .. " XP!")
end
