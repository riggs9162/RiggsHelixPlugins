local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(ply, char, oldChar)
    local music = PLUGIN.introMusic[ix.option.Get(ply, "introMusic", "hl1")].citizenMusic
    if ( char:IsCombine() ) then
        music = PLUGIN.introMusic[ix.option.Get(ply, "introMusic", "hl1")].combineMusic
    end

    ply:ConCommand("play "..table.Random(music))
end