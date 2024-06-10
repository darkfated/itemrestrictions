hook.Add('PostReloadToolsMenu', 'ItemRestrictions.RemoveTools', function()
    for _, v in pairs(g_SpawnMenu.ToolMenu.ToolPanels[1].List.pnlCanvas:GetChildren()) do
        for _, item in pairs(v:GetChildren()) do
            print(item.Name)
            if item.Name and ItemRestrictions.cfg.hide_tools[item.Name] then
                item:Remove()
            end
        end
    end
end)
