--[[
    * ItemRestrictions *
	GitHub: https://github.com/darkfated/itemrestrictions
    Author's discord: darkfated
]]--

local function run_scripts()
	Mantle.run_cl('config.lua')
	Mantle.run_sv('config.lua')

	Mantle.run_sv('server.lua')

	Mantle.run_sv('nets.lua')
	Mantle.run_cl('nets.lua')

	Mantle.run_cl('menu.lua')
end

local function init()
	ItemRestrictions = ItemRestrictions or {}

	run_scripts()
end

init()
