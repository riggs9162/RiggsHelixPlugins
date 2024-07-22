local PLUGIN = PLUGIN

PLUGIN.name = "Blacklisted Words"
PLUGIN.description = "Prevents players from sending messages with blacklisted words."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

if ( CLIENT ) then return end

PLUGIN.words = {
    "#freetheboys",
    "ackbar",
    "akbar",
    "anal",
    "assfuck",
    "ballsack",
    "blowjob",
    "brownskin",
    "buttplug",
    "chink",
    "cock",
    "coon",
    "cracker",
    "cum",
    "cunt",
    "cuntbag",
    "dick",
    "dildo",
    "dyke",
    "end your life",
    "f a g g o t",
    "fag",
    "faggot",
    "fagina",
    "fat ass",
    "free the boys",
    "freetheboys",
    "fuck yourself",
    "fuck",
    "fudgepacker",
    "fuhrer",
    "gaylord",
    "goodman",
    "gook",
    "heeb",
    "hentai",
    "jap",
    "jerk off",
    "jerkoff",
    "jizz",
    "kike",
    "kill yourself",
    "mangina",
    "mcfaggot",
    "mcnigbig",
    "mcnigga",
    "mcnigger",
    "mono-truth",
    "monotruth",
    "motherfucker",
    "n 1 g g a",
    "n 1 g g e r",
    "n i g g a",
    "n i g g e r",
    "n i g",
    "n1gga",
    "n1gger",
    "negan",
    "neger",
    "negro",
    "negus",
    "niga",
    "niger",
    "nigg",
    "nigga",
    "nigger",
    "niggy",
    "nigs",
    "nlgger",
    "porchmonkey",
    "retard",
    "sandnigger",
    "shemale",
    "skibidi",
    "slut",
    "spic",
    "towelhead",
    "tranny",
    "wetback",
    "whore",
    "wop",
    "zipperhead"
}

ix.log.AddType("blacklistedWord", function(ply, word, text)
    local format = "%s has attempted to send a message with the blacklisted word \"%s\" (%s)."
    format = format:format(ply:GetName(), word, text)

    return format
end)

function PLUGIN:PrePlayerMessageSend(ply, chatType, text)
    local bFound = nil
    for _, phrase in ipairs(self.words) do
        if ( ix.util.StringMatches(text, phrase) ) then
            bFound = phrase
            break
        end
    end

    if ( bFound and isstring(bFound) and string.len(bFound) > 0 ) then
        ix.log.Add(ply, "blacklistedWord", bFound, text)
        return false
    end
end