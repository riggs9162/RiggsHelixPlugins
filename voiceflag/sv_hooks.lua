local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(ply, char, oldChar)
    if ( char:HasFlags("v") ) then
        ply.ixAllowVoice = true
    else
        ply.ixAllowVoice = nil
    end
end

function PLUGIN:PlayerCanHearPlayersVoice(listener, talker)
    if ( !ix.config.Get("allowVoice") ) then return end

    if ( !listener.ixAllowVoice ) then
        return false
    end
end