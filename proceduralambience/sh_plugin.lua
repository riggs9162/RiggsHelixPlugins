local PLUGIN = PLUGIN

PLUGIN.name = "Procedural Ambience"
PLUGIN.description = "Adds a procedural ambience system to the server."
PLUGIN.author = "Reece™"

ix.ambience = ix.ambience or {}
ix.ambience.list = ix.ambience.list or {}

function ix.ambience.LoadAmbiences(directory)
    for _, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
        -- Get the name without the "sh_" prefix and ".lua" suffix.
        local niceName = v:sub(4, -5)
        -- Determine a numeric identifier for this ambience.
        local index = #ix.ambience.list + 1
        local halt

        for _, v2 in ipairs(ix.ambience.list) do
            if (v2.uniqueID == niceName) then
                halt = true
            end
        end

        if (halt == true) then
            continue
        end

        -- Set up a global table so the file has access to the ambience table.
        AMBIENCE = {index = index, uniqueID = niceName}
            AMBIENCE.name = "Unknown"
            AMBIENCE.description = "No description available."
            
            ix.util.Include(directory.."/"..v, "shared")

            ix.ambience.list[niceName] = AMBIENCE
        AMBIENCE = nil
    end
end

concommand.Add("ix_ambience_play", function(ply, cmd, args)
    if ( ply:IsSuperAdmin() and args[1] ) then
        if not ( ix.ambience.list[args[1]] ) then
            ply:Notify("This Ambience type does not exist!")
            return false
        end

        if not ( ix.ambience.list[args[1]].map and ix.ambience.list[args[1]].map == game.GetMap() ) then
            ply:Notify("This Ambience type is not available on this map!")
            return false
        end

        ix.ambience.list[args[1]].onPlay(ix.ambience.list[args[1]])
    end
end)

if ( CLIENT ) then
    concommand.Add("ix_debug_pos", function(ply)
        local pos = ply:GetPos()
    
        local output = "Vector("..pos.x..", "..pos.y..", "..pos.z..")"
        chat.AddText(output)
    
        SetClipboardText(output)
    end)
    
    concommand.Add("ix_debug_eyepos", function(ply)
        local pos = ply:EyePos()
    
        local output = "Vector("..pos.x..", "..pos.y..", "..pos.z..")"
        chat.AddText(output)
    
        SetClipboardText(output)
    end)
    
    concommand.Add("ix_debug_ang", function(ply)
        local pos = ply:EyeAngles()
    
        local output = "Angle("..pos.p..", "..pos.y..", "..pos.r..")"
        chat.AddText(output)
    
        SetClipboardText(output)
    end)
end

function easedLerpVector(fraction, from, to)
	return LerpVector(math.ease.InCubic(fraction), from, to)
end

ix.ambience.LoadAmbiences(engine.ActiveGamemode().."/plugins/proceduralambience/ambience")