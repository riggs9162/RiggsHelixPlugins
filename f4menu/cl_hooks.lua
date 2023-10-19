local PLUGIN = PLUGIN

function PLUGIN:Think()
    if ( input.IsKeyDown(KEY_F4) and not vgui.CursorVisible() ) then
        vgui.Create("ixF4Menu")
    end
end