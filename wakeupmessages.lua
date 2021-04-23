PLUGIN.name = "Spawn Notifications"
PLUGIN.author = "SPURION - Messages, Riggs - All of the code."
PLUGIN.desc = "A notification which tells the player their status on loading the character."

function PLUGIN:CharacterLoaded(character)
	local client = character:GetPlayer()
	timer.Simple(2, function()
		if not (client:IsValid() or client:Alive()) then return end
        local wakeupmessages = {
            "You awaken with sweat all over your body, its humid.",
            "You awaken to the sound of sand in the air, somewhere theres a fight going on.",
            "You awaken to the feeling of rage, you seek combat.",
            "You open your eyes to the landscape, it feels different from home."
        }
		if (client:Health() < 50) then -- replaces the original messages with other messages depending on the function.
            wakeupmessages = {
                "You awaken with wounds all over your body, its humid and painful.",
                "The sound of gun fire has woke you up, your wounds sting your body.",
                "You have woken up from a nightmare involving you getting shot, your wound from before has stung where you was shot in the dream."
            }
		end
		client:ConCommand("stopsound")
		client:ConCommand("play music/stingers/hl1_stinger_song16.mp3")
		client:ChatPrint(table.Random(wakeupmessages))
		client:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 2, 1)
	end)
end