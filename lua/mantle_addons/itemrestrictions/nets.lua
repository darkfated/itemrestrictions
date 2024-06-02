if SERVER then
    util.AddNetworkString('ItemRestrictions-GetData')
    util.AddNetworkString('ItemRestrictions-SendData')
    util.AddNetworkString('ItemRestrictions-Edit')
    
    net.Receive('ItemRestrictions-GetData', function(_, pl)
        net.Start('ItemRestrictions-SendData')
            net.WriteTable(ItemRestrictions.access)
        net.Send(pl)
    end)

    net.Receive('ItemRestrictions-Edit', function(_, pl)
        if !pl:IsSuperAdmin() then
            return
        end

        local data = net.ReadTable()
        local bool = net.ReadBool()
        local usergroup = data[1]
        local t = data[2]
        local classname = data[3]

        if !ItemRestrictions.access[t][usergroup] then
            ItemRestrictions.access[t][usergroup] = {}
        end

        if table.HasValue(ItemRestrictions.access[t][usergroup], classname) then
            table.RemoveByValue(ItemRestrictions.access[t][usergroup], classname)

            if table.IsEmpty(ItemRestrictions.access[t][usergroup]) then
                ItemRestrictions.access[t][usergroup] = nil
            end
        else
            table.insert(ItemRestrictions.access[t][usergroup], classname)
        end

        file.Write('ir.json', util.TableToJSON(ItemRestrictions.access))
    end)
else
    net.Receive('ItemRestrictions-SendData', function()
        local tbl = net.ReadTable()

        ItemRestrictions.access = tbl
    end)
end
