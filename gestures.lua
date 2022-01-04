local PLUGIN = PLUGIN

PLUGIN.name = "Player Gestures"
PLUGIN.description = "Adds gestures that can be used for certain supported animations. Major thanks to Wicked Rabbit for showing me how it works!"
PLUGIN.author = "Riggs Mackay"

-- Don't bother DMing me to add female variants, do it yourself.
PLUGIN.gestures = { -- Mainly for the citizen_male models, or models that include the citizen male gestures
    -- citizen rp go brrrr...
    {gesture = "g_salute", command = "Salute", id = 1444},
    {gesture = "g_antman_dontmove", command = "DontMove", id = 1445},
    {gesture = "g_antman_stayback", command = "StayBack", id = 1446},
    {gesture = "g_armsout", command = "ArmSout", id = 1447},
    {gesture = "g_armsout_high", command = "ArmSoutHigh", id = 1448},
    {gesture = "g_chestup", command = "ChestUp", id = 1449},
    {gesture = "g_clap", command = "Clap", id = 1450},
    {gesture = "g_fist_L", command = "FistLeft", id = 1451},
    {gesture = "g_fist_r", command = "FistRight", id = 1452},
    {gesture = "g_fist_swing_across", command = "FistSwing", id = 1453},
    {gesture = "g_fistshake", command = "FistShake", id = 1454},
    {gesture = "g_frustrated_point_l", command = "PointFrustrated", id = 1455},
    {gesture = "G_noway_big", command = "No", id = 1456},
    {gesture = "G_noway_small", command = "NoSmall", id = 1457},
    {gesture = "g_plead_01", command = "Plead", id = 1458},
    {gesture = "g_point", command = "Point", id = 1459},
    {gesture = "g_point_swing", command = "PointSwing", id = 1460},
    {gesture = "g_pointleft_l", command = "PointLeft", id = 1461},
    {gesture = "g_pointright_l", command = "PointRight", id = 1462},
    {gesture = "g_present", command = "Present", id = 1463},
    {gesture = "G_shrug", command = "Shrug", id = 1464},
    {gesture = "g_thumbsup", command = "ThumbsUp", id = 1465},
    {gesture = "g_wave", command = "Wave", id = 1466},
    {gesture = "G_what", command = "What", id = 1467},
    {gesture = "hg_headshake", command = "HeadShake", id = 1468},
    {gesture = "hg_nod_no", command = "HeadNo", id = 1469},
    {gesture = "hg_nod_yes", command = "HeadYes", id = 1470},
    {gesture = "hg_nod_left", command = "HeadLeft", id = 1471},
    {gesture = "hg_nod_right", command = "HeadRight", id = 1472},

    --{gesture = "hg_nod_right", command = "HeadRight", id = 1473},
}

function PLUGIN:DoAnimationEvent(ply, event, data)
    if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
        for k, v in pairs(PLUGIN.gestures) do
            if ( data == v.id ) then
                ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, ply:LookupSequence(v.gesture), 0, true)

                return ACT_INVALID
            end
        end
    end
end

for k, v in pairs(PLUGIN.gestures) do
    local commandname = string.Replace(v.gesture, "hg_", "")
    commandname = string.Replace(commandname, "g_", "")
    commandname = string.Replace(commandname, "antman_", "")
    commandname = string.Replace(commandname, "_", " ")

    concommand.Add("ix_act_"..v.command, function(ply, cmd, args)
        ply:DoAnimationEvent(v.id)
    end)

    ix.command.Add("Gesture"..v.command, {
        description = "Play the "..commandname.." gesture.",
        OnCanRun = function(_, ply)
            if ply:IsFemale() then
                return "Female variants are not supported."
            end
        end,
        OnRun = function(_, ply)
            if ( SERVER ) then
                ply:ConCommand("ix_act_"..v.command)
            end
        end
    })
end

if ( SERVER ) then
    local allowedChatTypes = {
        ["ic"] = true,
        ["w"] = true,
        ["y"] = true,
    }
    function PLUGIN:PrePlayerMessageSend(ply, chatType, message, bAnonymous)
        if ( allowedChatTypes[chatType] ) then
            if ( message:find("!") ) then
                ply:ConCommand("ix_act_fistswing")
            elseif ( message:find("?") ) then
                ply:ConCommand("ix_act_what")
            end
        end
    end
end
