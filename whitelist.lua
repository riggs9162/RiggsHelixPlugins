local PLUGIN = PLUGIN

PLUGIN.name = "Whitelist System"
PLUGIN.description = "Allows players who are whitelisted, to join the server."
PLUGIN.author = "Riggs.mackay"
PLUGIN.discord = "https://discord.gg/Y8wXVdd4WB"

PLUGIN.whitelists = {
    ["STEAM_0:1:1395956"] = {
        discord = "Riggs.mackay™#0001",
        whitelisted = false,
    },
    ["STEAM_0:1:206522106"] = {
        discord = "Apsy#0001",
        whitelisted = true,
    }
}

if ( SERVER ) then
    function PLUGIN:PlayerAuthed(ply, steamid)
        local trg = self.whitelists[steamid]
        if not ( trg ) then ply:Kick("You are not registered on our whitelist system, please redirect to "..self.discord) return end

        if ( trg.whitelisted == true ) then
            return
        end

        ply:Kick("You are not whitelisted.")
        
        for k, v in ipairs(player.GetAll()) do
            if ( v:IsAdmin() ) then
                if ( trg.discord ) then
                    v:ChatNotify("[WHITELIST] " .. ply:SteamName() .. " has been kicked for not being whitelisted. Their noted discord name is: ".. trg.discord)
                else
                    v:ChatNotify("[WHITELIST] " .. ply:SteamName() .. " has been kicked for not being whitelisted.")
                end
            end
        end
    end
end
