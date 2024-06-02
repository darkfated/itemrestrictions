local function Open(active_usergroup)
    if IsValid(menu_ir) then
        menu_ir:Remove()
    end

    menu_ir = vgui.Create('DFrame')
    Mantle.ui.frame(menu_ir, 'ItemRestrictions', 420, 400, true)
    menu_ir:Center()
    menu_ir:MakePopup()
    menu_ir.center_title = 'Edit access'

    if !active_usergroup then
        active_usergroup = 'user'
    end

    local main_panel = vgui.Create('DPanel', menu_ir)
    main_panel:Dock(FILL)
    main_panel.Paint = nil

    local function CreatePageList(pnl, t)
        pnl:DockPadding(6, 6, 6, 6)
        pnl.Paint = function(_, w, h)
            surface.SetDrawColor(45, 45, 45)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
        end

        local tabl = list.Get(t)

        local sp = vgui.Create('DScrollPanel', pnl)
        Mantle.ui.sp(sp)
        sp:Dock(FILL)

        for i, item in pairs(tabl) do
            if t == 'Weapon' and !item.Spawnable then continue end

            local icon
            
            if t == 'Weapon' then   
                icon = item.IconOverride or 'entities/' .. item.ClassName .. '.png'
            else
                icon = item.IconOverride or 'entities/' .. i .. '.png'
            end

            local has_access = true
            
            if ItemRestrictions.access[t][active_usergroup] then
                has_access = !table.HasValue(ItemRestrictions.access[t][active_usergroup], item.ClassName)
            end

            local btn_item = vgui.Create('DButton', sp)
            Mantle.ui.btn(btn_item, Material(icon), 60, !has_access and Color(172, 51, 51) or nil, nil, nil, nil, true)
            btn_item:Dock(TOP)
            btn_item:DockMargin(0, 0, 0, 6)
            btn_item:SetTall(60)
            btn_item:SetText(item.PrintName or item.ClassName)
            btn_item.DoClick = function()
                net.Start('ItemRestrictions-Edit')
                    net.WriteTable({active_usergroup, t, item.ClassName})
                    net.WriteBool(!has_access)
                net.SendToServer()

                RunConsoleCommand('itemrestrictions_menu', active_usergroup)
            end
        end
    end

    local function CreateSettings()
        main_panel:Clear()

        local tabs = Mantle.ui.panel_tabs(main_panel)

        local panel_entities = vgui.Create('DPanel')
        CreatePageList(panel_entities, 'SpawnableEntities')
        tabs:AddTab('Entities', panel_entities, 'icon16/bricks.png')

        local panel_sweps = vgui.Create('DPanel')
        CreatePageList(panel_sweps, 'Weapon')
        tabs:AddTab('Sweps', panel_sweps, 'icon16/gun.png')

        tabs:ActiveTab('Entities')
    end

    CreateSettings()

    local btn_usergroup = vgui.Create('DButton', menu_ir)
    Mantle.ui.btn(btn_usergroup, nil, nil, Color(172, 51, 51), nil, nil, nil, true)
    btn_usergroup:Dock(TOP)
    btn_usergroup:SetText('')

    btn_usergroup.DoClick = function()
        local DM = Mantle.ui.derma_menu()

        for _, v in ipairs(ItemRestrictions.usergroups) do
            DM:AddOption(v, function()
                active_usergroup = v
                
                CreateSettings()
            end)
        end
    end
    btn_usergroup.PaintOver = function(self)
        if self:IsHovered() then
            self.btn_text = 'Click to select a privilege'
        else
            self.btn_text = 'Active: ' .. active_usergroup          
        end
    end

    local panel_split = vgui.Create('DPanel', menu_ir)
    panel_split:Dock(TOP)
    panel_split:DockMargin(0, 8, 0, 8)
    panel_split:SetTall(8)
    panel_split.Paint = function(_, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Mantle.color.panel[1])
    end
end

concommand.Add('itemrestrictions_menu', function(_, _, args)
    local usergroup = args[1]

    net.Start('ItemRestrictions-GetData')
    net.SendToServer()

    timer.Simple(0.5, function()
        Open(usergroup)
    end)
end)
