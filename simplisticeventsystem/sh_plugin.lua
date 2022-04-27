local PLUGIN = PLUGIN

PLUGIN.name = "Simplistic Event System"
PLUGIN.description = "A Simplistic Event System, mainly used to play sound effects or music tracks."
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2022 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

ix.util.Include("sv_plugin.lua")

if ( CLIENT ) then
    net.Receive("ixPlaySound", function(len, ply)
        LocalPlayer():EmitSound(tostring(net.ReadString()), tonumber(net.ReadUInt(7)) or 100)
    end)
    
    net.Receive("ixCreateVGUI", function(len, ply)
        vgui.Create(tostring(net.ReadString()))
    end)

    surface.CreateFont("RiggsFontShadow30", {
        font = "Segoe Ui",
        size = 30,
        weight = 1000,
        antialias = true,
        shadow = true,
    })

    surface.CreateFont("RiggsFont28", {
        font = "Segoe Ui",
        size = 28,
        weight = 1000,
        antialias = true,
    })

    surface.CreateFont("RiggsFont18", {
        font = "Segoe Ui",
        size = 18,
        weight = 1000,
        antialias = true,
    })
end

ix.adminSystem = ix.adminSystem or {}
ix.adminSystem.music = ix.adminSystem.music or {}
ix.adminSystem.derma = ix.adminSystem.derma or {}

-- Configuration below.

ix.adminSystem.music = {
    ["Half-Life 2 Music"] = {
        {"CP Violation", "music/hl2_song20_submix0.mp3"},
        {"Hazardous Environments", "music/hl1_song10.mp3"},
        {"The Innsbruck Experiment", "music/hl2_song4.mp3"},
        {"Brane Scan", "music/hl2_song31.mp3"},
        {"Dark Energy", "music/hl2_song3.mp3"},
        {"Requiem For Ravenholm", "music/ravenholm_1.mp3"},
        {"Pulse Phase", "music/hl2_song6.mp3"},
        {"Ravenholm Reprise", "music/hl2_song7.mp3"},
        {"Probably Not a Problem", "music/hl2_song33.mp3"},
        {"Calabi-Yau Model", "music/hl2_song30.mp3"},
        {"Slow Light", "music/hl2_song32.mp3"},
        {"Apprehension and Evasion", "music/hl2_song29.mp3"},
        {"Hunter Down", "music/hl2_song28.mp3"},
        {"Our Resurrected Teleport", "music/hl2_song26.mp3"},
        {"Triage at Dawn", "music/hl2_song23_suitsong3.mp3"},
        {"Lab Practicum", "music/hl2_song2.mp3"},
        {"Nova Prospekt", "music/hl2_song19.mp3"},
        {"Broken Symmetry", "music/hl2_song17.mp3"},
        {"LG Orbifold", "music/hl2_song16.mp3"},
        {"Kaon", "music/hl2_song15.mp3"},
        {"You're Not Supposed to Be Here", "music/hl2_song14.mp3"},
        {"Suppression Field", "music/hl2_song13.mp3"},
        {"Hard Fought", "music/hl2_song12_long.mp3"},
        {"Particle Ghost", "music/hl2_song1.mp3"},
        {"Shadows Fore and Aft", "music/hl2_intro.mp3"},
        {"Neutrino Trap", "music/hl1_song9.mp3"},
        {"Zero Point Energy Field", "music/hl1_song6.mp3"},
        {"Echoes of a Resonance Cascade", "music/hl1_song5.mp3"},
        {"Black Mesa Inbound", "music/hl1_song3.mp3"},
        {"Xen Relay", "music/hl1_song26.mp3"},
        {"Tracking Device", "music/hl1_song25_remix3.mp3"},
        {"Singularity", "music/hl1_song24.mp3"},
        {"Dirac Shore", "music/hl1_song21.mp3"},
        {"Escape Array", "music/hl1_song20.mp3"},
        {"Negative Pressure", "music/hl1_song19.mp3"},
        {"Tau-9", "music/hl1_song17.mp3"},
        {"Something Secret Steers Us", "music/hl1_song15.mp3"},
        {"Triple Entanglement", "music/hl1_song14.mp3"},
        {"Lambda Core", "music/hl1_song10.mp3"},
        {"Entanglement", "music/hl2_song0.mp3"},
        {"Highway 17", "music/hl2_song8.mp3"},
        {"A Red Letter Day", "music/hl2_song10.mp3"},
        {"Sandtraps", "music/hl2_song11.mp3"},
        {"Train Station 1", "music/hl2_song26_trainstation1.mp3"},
        {"Train Station 2", "music/hl2_song27_trainstation2.mp3"},
    },
    ["Custom Music"] = {
        {"Strider Battle Garage", "Ace/music/strider_battle_garage.ogg"},
        -- If these values are blank, you will not see them in the menu. > ix_eventmenu
        {"", ""},
        {"", ""},
        {"", ""},
        {"", ""},
        {"", ""},
    }
}
