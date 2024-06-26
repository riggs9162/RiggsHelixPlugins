local PLUGIN = PLUGIN

PLUGIN.name = "Whitelist System"
PLUGIN.description = "Allows players who are whitelisted, to join the server."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

PLUGIN.whitelists = {
    ["STEAM_0:1:1395956"] = {
        discord = "riggs9162", // Discord name of the player.
        whitelisted = true, // Allow or disallow the player to join.
    },
}

if ( SERVER ) then
    function PLUGIN:PlayerAuthed(ply, steamid)
        local steamID64 = util.SteamIDTo64(steamid)
        local whitelistData = self.whitelists[steamid] or self.whitelists[steamID64]

        if not ( whitelistData ) then
            ply:Kick("You are not whitelisted!")

            return
        end

        if ( whitelistData.whitelisted ) then
            return
        end

        ply:Kick("You are not whitelisted.")

        for k, v in player.Iterator() do
            if ( IsValid(v) and v:IsAdmin() ) then
                if ( whitelistData.discord ) then
                    v:ChatNotify("[WHITELIST] " .. ply:SteamName() .. " has been kicked for not being whitelisted. Their noted discord name is: ".. self.whitelists[steamid].discord)

                    return
                end

                v:ChatNotify("[WHITELIST] " .. ply:SteamName() .. " has been kicked for not being whitelisted.")
            end
        end
    end
end