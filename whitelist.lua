local PLUGIN = PLUGIN

PLUGIN.name = "Whitelist System"
PLUGIN.description = "Allows players who are whitelisted, to join the server."
PLUGIN.author = "Riggs.mackay"
PLUGIN.schema = "Any"
PLUGIN.version = "1.0"

PLUGIN.whitelists = {
    ["STEAM_0:1:1395956"] = {
        discord = "Riggs.mackay™#0001", -- Discord ID & Name incase you want to note it down.
        whitelisted = true, -- Allow/Disallow
    },
}

if ( SERVER ) then
    function PLUGIN:PlayerAuthed(ply, steamid)
        if not ( self.whitelists[steamid] and self.whitelists[steamid].whitelisted == true ) then
            ply:Kick("You are not whitelisted.")
            
            for k, v in pairs(player.GetAll()) do
                if ( IsValid(v) and v:IsAdmin() ) then
                    if ( self.whitelists[steamid].discord ) then
                        v:ChatNotify("[WHITELIST] " .. ply:SteamName() .. " has been kicked for not being whitelisted. Their noted discord name is: ".. self.whitelists[steamid].discord)
                    else
                        v:ChatNotify("[WHITELIST] " .. ply:SteamName() .. " has been kicked for not being whitelisted.")
                    end
                end
            end
        end
    end
end
