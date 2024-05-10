local PLUGIN = PLUGIN

PLUGIN.name = "Procedural Ambience"
PLUGIN.description = "Adds a procedural ambience system to the server."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

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