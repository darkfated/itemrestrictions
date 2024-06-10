hook.Add('Initialize', 'ItemRestrictions.LoadData', function()
    local saved_data

    if file.Exists('ir.json', 'DATA') then
        saved_data = util.JSONToTable(file.Read('ir.json', 'DATA'))
    else
        saved_data = {
            SpawnableEntities = {},
            Weapon = {}
        }
    end

    ItemRestrictions.access = saved_data
end)

// Checks
local color_theme = Color(64, 179, 154)

local function CanPlayerUse(t, pl, class)
    local group = pl:GetUserGroup()
    local has_access = false

    if ItemRestrictions.access[t][group] then
        if pl:IsSuperAdmin() then return true end
        if group == 'root' then return true end

        has_access = table.HasValue(ItemRestrictions.access[t][group], class)
    end

    if !has_access then
        Mantle.notify(pl, color_theme, 'ItemRestrictions', 'Нету доступа к ' .. class)
    end

    return has_access
end

hook.Add('PlayerGiveSWEP', 'ItemRestrictions', function(pl, class)
    return CanPlayerUse('Weapon', pl, class)
end)

hook.Add('PlayerSpawnSWEP', 'ItemRestrictions', function(pl, class)
    return CanPlayerUse('Weapon', pl, class)
end)

hook.Add('PlayerSpawnSENT', 'ItemRestrictions', function(pl, class)
    return CanPlayerUse('SpawnableEntities', pl, class)
end)

hook.Add('PlayerSpawnProp', 'ItemRestrictions', function(pl)
    return CanPlayerUse('SpawnableEntities', pl, 'prop_physics')
end)

hook.Add('CanTool', 'ItemRestrictions', function(pl, _, mode)
    if ItemRestrictions.cfg.hide_tools[mode] then
        Mantle.notify(pl, color_theme, 'ItemRestrictions', 'Нету доступа к инструменту ' .. mode)

        return false
    end
end)
