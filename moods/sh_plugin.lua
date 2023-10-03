local PLUGIN = PLUGIN

PLUGIN.name = "Moods"
PLUGIN.description = "Allows you to add new mood types for different types of animation classes."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2023 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

PLUGIN.moodAffectedWeapons = {
    ["ix_hands"] = true,
    ["ix_keys"] = true,
}
PLUGIN.moods = {}
PLUGIN.moods["citizen_male"] = {
    {
        [ACT_MP_STAND_IDLE] = "lineidle03",
        [ACT_MP_WALK] = "plaza_walk_all",
    },
    {
        [ACT_MP_STAND_IDLE] = "lineidle02",
        [ACT_MP_WALK] = "pace_all",
    },
    {
        [ACT_MP_RUN] = "run_all_panicked",
    },
    {
        [ACT_MP_STAND_IDLE] = "scaredidle",
        [ACT_MP_WALK] = "walk_panicked_all",
        [ACT_MP_RUN] = "sprint_all",
    },
}

ix.char.RegisterVar("mood", {
    field = "mood",
    fieldType = ix.type.number,
    default = 0,
})

ix.command.Add("SetMood", {
    description = "Set's your mood type for your current character.",
    arguments = {
        ix.type.number,
    },
    OnCanRun = function(self, ply, moodType)
        local moodData = PLUGIN.moods[ix.anim.GetModelClass(ply:GetModel())]
        return moodData and moodType <= #moodData
    end,
    OnRun = function(self, ply, moodType)
        if not ( ply:GetCharacter() ) then
            return
        end
        
        ply:GetCharacter():SetMood(moodType)
        ply:Notify("You set your character's mood type to "..moodType.."!")
    end,
})

ix.util.Include("sh_hooks.lua")