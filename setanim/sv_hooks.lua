local PLUGIN = PLUGIN

function PLUGIN:SaveData()
    ix.data.Set("animclasses", self.stored, false, true)
end

util.AddNetworkString("ixSetAnimClasses")
function PLUGIN:LoadData()
    self.stored = ix.data.Get("animclasses", {}, false, true)

    net.Start("ixSetAnimClasses")
        net.WriteTable(self.stored)
    net.Broadcast()

    for k, v in ipairs(self.stored) do
        local modelTable = ix.anim.GetModelClass(k)
        if not ( modelTable ) then
            ix.anim.SetModelClass(k, v)
        end
    end
end