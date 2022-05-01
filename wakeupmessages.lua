PLUGIN.name = "Spawn Notifications"
PLUGIN.description = "A notification which tells the player their status on loading the character."
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2022 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

-- Feel free to change any of these messages.
local wakeupmessages = {
    "You wake up from a long nap and recover from your sleep.",
    "You stand up and sniffing the fresh air from the world.",
    "You start to stand up and recover from your sleep.",
    "You are sweating from all the scare you have been getting from your deam and you wake up.",
    "You were dreaming of someone and you heard their voice, you started to wake up.",
    "You hear a small whisper in your ear, after that you hear loud footsteps fading away, you wake up being scared.",
    "You hear a loud helicopter overhead of yourself and you instantly wake up.",
    "You heard a growling and you started to wake up but scared.",
    "You heard a loud siren and you are scared of the noise.",
}

function PLUGIN:PlayerSpawn(ply)
    if not ( ply:IsValid() or ply:Alive() or ply:GetCharacter() ) then return end

    ply:ConCommand("play music/stingers/hl1_stinger_song16.mp3")
    ply:ScreenFade(SCREENFADE.IN, color_black, 3, 2)
    ply:ChatPrint(math.random(1, #wakeupmessages))
end
