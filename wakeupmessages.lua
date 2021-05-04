PLUGIN.name = "Spawn Notifications"
PLUGIN.author = "Riggs"
PLUGIN.description = "A notification which tells the player their status on loading the character."

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

function PLUGIN:CharacterLoaded(char)
	if not (char:GetPlayer():IsValid() or char:GetPlayer():Alive()) then return end
	if not (char) then return end
	local client = char:GetPlayer()
	client:ConCommand("stopsound")
	client:ConCommand("play music/stingers/hl1_stinger_song16.mp3")
	client:ScreenFade(SCREENFADE.IN, color_black, 3, 2)
	client:ChatPrint(table.Random(wakeupmessages))
end