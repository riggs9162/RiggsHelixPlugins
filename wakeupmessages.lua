local PLUGIN = PLUGIN

PLUGIN.name = "Wake Up Messages"
PLUGIN.description = "Adds a random message when a player loads their character."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

PLUGIN.wakeUpMessages = {
    "blinks groggily, adjusting to the light as the world comes back into focus.",
    "leisurely rises from their nap, ready to face the world with renewed energy.",
    "luxuriates in the comfort of waking up, relishing the sensation of a well-deserved nap.",
    "opens their eyes, greeted by the tranquility that follows a restorative period of sleep.",
    "reflects on the dreamy haze of slumber, slowly reconnecting with the waking world.",
    "rubs sleep from their eyes, feeling the warmth of waking after a restful nap.",
    "shakes off the remnants of sleep, ready to tackle the day with refreshed enthusiasm.",
    "smiles contentedly, embracing the serenity that lingers after a satisfying nap.",
    "stretches and yawns, slowly emerging from a peaceful slumber.",
    "takes a deep breath, savoring the fresh feeling of a new beginning after a long nap."
}

function PLUGIN:PlayerLoadedCharacter(ply, char, oldChar)
    if not ( IsValid(ply) ) then
        return
    end

    if not ( char ) then
        return
    end

    local message = self.wakeUpMessages[math.random(#self.wakeUpMessages)]
    ix.chat.Send(ply, "me", message)
end