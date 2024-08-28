ix.achievements = ix.achievements or {}
ix.achievements.stored = {}

/*
Achievemt structure

local achievement = {
    name = "Achievement Name",
    description = "Achievement Description",
    icon = "icon16/award_star_gold_1.png",
    OnCompleted = function(client)
        print(client:Name() .. " has completed the achievement " .. achievement.name)
    end
}

ix.achievements:Register(achievement)
*/

function ix.achievements:Register(info)
    if ( !info.name or !info.description or !info.icon ) then
        ErrorNoHaltWithStack("Attempt to register an achievement without a name, description or icon!")
        return
    end

    if ( ix.achievements:Get(info.name) ) then
        ErrorNoHaltWithStack("Attempt to register an achievement with a name that is already registered!")
        return
    end

    info.index = table.Count(self.stored) + 1

    self.stored[info.index] = info
end

function ix.achievements:GetAll()
    return self.stored
end

function ix.achievements:GetByIndex(index)
    return self.stored[index]
end

// Taken from my edit of the Helix Framework
local function advancedSearch(a, b)
    if (a and b) then
        a = tostring(a)
        b = tostring(b)
        
        local a2, b2 = a:utf8lower(), b:utf8lower()

        -- Check if the actual letters match.
        if (a == b) then return true end
        if (a2 == b2) then return true end

        -- Be less strict and search.
        if (a:find(b)) then return true end
        if (a2:find(b2)) then return true end

        -- Take apart the strings into tables of words.
        for _, v in ipairs(string.Explode("%s", a2, true)) do
            for _, v2 in ipairs(string.Explode("%s", b2, true)) do
                -- Now check if the words match.
                if (ix.util.StringMatches(v, v2)) then
                    return true
                end
            end
        end
    end

    return false

function ix.achievements:Get(identifier)
    for _, achievement in ipairs(self.stored) do
        if ( achievement.index == tonumber(identifier) ) then
            return achievement
        end

        if ( advancedSearch(achievement.name, identifier) ) then
            return achievement
        end

        if ( advancedSearch(achievement.icon, identifier) ) then
            return achievement
        end

        if ( advancedSearch(achievement.description, identifier) ) then
            return achievement
        end
    end
end

if ( SERVER ) then
    function ix.achievements:Complete(char, identifier)
        local achievement = self:Get(identifier)

        if ( achievement ) then
            local data = char:GetData("achievements", {})
            if ( !data[achievement.index] ) then
                data[achievement.index] = true

                if ( achievement.OnCompleted ) then
                    achievement:OnCompleted(char:GetPlayer())
                end

                char:SetData("achievements", data)
                char:Save()

                local ply = char:GetPlayer()
                if ( IsValid(ply) ) then
                    ply:Notify("You have completed the following achievement \"" .. achievement.name .. "\"!")
                end
            end
        else
            ErrorNoHaltWithStack("Attempt to complete an achievement that doesn't exist!")
        end
    end
end

function ix.achievements:Completed(char, identifier)
    local achievement = self:Get(identifier)

    if ( achievement ) then
        local data = char:GetData("achievements", {})
        return data[achievement.index] or false
    else
        ErrorNoHaltWithStack("Attempt to check if an achievement is completed that doesn't exist!")
    end
end