local PLUGIN = PLUGIN

function PLUGIN:OnCharacterCreated(client, character)
    if ( ix.config.Get("giveOnCreate") and !character:HasFlags("v") ) then
        character:GiveFlags("v")
    end
end

function PLUGIN:PlayerLoadedCharacter(client, character, oldChar)
    local clientTable = client:GetTable()
    if ( character:HasFlags("v") ) then
        clientTable.ixAllowVoice = true
    else
        clientTable.ixAllowVoice = nil
    end
end

local nextCheck = 0
function PLUGIN:PlayerCanHearPlayersVoice(listener, talker)
    if ( CurTime() < nextCheck ) then return end
    nextCheck = CurTime() + 0.1 -- for the sake of performance

    if ( !ix.config.Get("allowVoice") ) then return end

    local talkerTable = talker:GetTable()
    if ( !talkerTable.ixAllowVoice ) then
        return false
    end
end
