local PLUGIN = PLUGIN

PLUGIN.name = "Faction Specific Animations"
PLUGIN.description = "This plugin allows you to set faction specific animations for your factions."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
PLUGIN.readme = [[
Using this plugin, will add a new key to the faction file called "animClass". This key will be used to determine the animation class that the faction will use. Meaning that if you have a faction called "police" and you want them to use the "metrocop" animation class, you would add the following to the faction file:

```lua
FACTION.animClass = "metrocop"
```

This will make it so that the police faction will use the "metrocop" animation class, and all other models that do not support the "metrocop" animation class won't be able to use it.

Helix comes with a few preset animation classes for you to utilize, here is a list of them:
- citizen_male
- citizen_female
- metrocop
- overwatch
- vortigaunt
- player
- zombie
- fastZombie

If the key is not present, the default animations will be used if they exist.

If you want to use the default animations, you can simply remove the "animClass" key from the faction file, and the default animations will be used, if they exist.
]]

local oldGetModelClass = oldGetModelClass or ix.anim.GetModelClass

/// Gets a model's animation class.
// @realm shared
// @string model Model to get the animation class for
// @treturn[1] string Animation class of the model
// @treturn[2] nil If there was no animation associated with the given model
// @usage ix.anim.GetModelClass("models/police.mdl")
// > metrocop
function ix.anim.GetModelClass(model)
    local ply = LocalPlayer()
    local faction = ply:Team()
    local factionData = ix.faction.indices[faction]
    if ( factionData and factionData.animClass and ix.anim[factionData.animClass] ) then
        return factionData.animClass
    end

    return oldGetModelClass(model)
end