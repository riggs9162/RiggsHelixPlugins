local PLUGIN = PLUGIN

PLUGIN.name = "Whitelist System"
PLUGIN.description = "Allows players who are whitelisted, to join the server."
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2022 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

PLUGIN.whitelists = {
    ["STEAM_0:1:1395956"] = {
        discord = "Riggs Mackay™#0001", -- Discord ID & Name incase you want to note it down.
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
