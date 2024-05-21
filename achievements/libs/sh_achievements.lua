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

ix.achievements.Register(achievement)
*/

function ix.achievements.Register(info)
    if not ( info.name and info.description and info.icon ) then
        ErrorNoHalt("Attempt to register an achievement without a name, description or icon!")
        return
    end

    if ( ix.achievements.Get(info.name) ) then
        ErrorNoHalt("Attempt to register an achievement with a name that is already registered!")
        return
    end

    info.index = table.Count(ix.achievements.stored) + 1

    ix.achievements.stored[info.index] = info
end

function ix.achievements.GetAll()
    return ix.achievements.stored
end

function ix.achievements.GetByIndex(index)
    return ix.achievements.stored[index]
end

function ix.achievements.Get(identifier)
    identifier = string.lower(identifier)

    for _, achievement in ipairs(ix.achievements.stored) do
        if ( achievement.index == tonumber(identifier) ) then
            return achievement
        end

        if ( string.find(string.lower(achievement.name), identifier) ) then
            return achievement
        end

        if ( string.find(string.lower(achievement.icon), identifier) ) then
            return achievement
        end

        if ( string.find(string.lower(achievement.description), identifier) ) then
            return achievement
        end
    end
end

if ( SERVER ) then
    function ix.achievements.Complete(char, identifier)
        local achievement = ix.achievements.Get(identifier)

        if ( achievement ) then
            local data = char:GetData("achievements", {})
            if not ( data[achievement.index] ) then
                data[achievement.index] = true

                if ( achievement.OnCompleted ) then
                    achievement.OnCompleted(char:GetPlayer())
                end

                char:SetData("achievements", data)

                char:GetPlayer():Notify("Your character has completed the following achievement \"" .. achievement.name .. "\"!")
            end
        else
            ErrorNoHalt("Attempt to complete an achievement that doesn't exist!")
        end
    end
end

function ix.achievements.Completed(char, identifier)
    local achievement = ix.achievements.Get(identifier)

    if ( achievement ) then
        local data = char:GetData("achievements", {})
        return data[achievement.index] or false
    else
        ErrorNoHalt("Attempt to check if an achievement is completed that doesn't exist!")
    end
end