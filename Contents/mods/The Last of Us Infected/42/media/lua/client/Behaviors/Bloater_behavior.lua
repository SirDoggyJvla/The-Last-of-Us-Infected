--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

The Bloater behavior is written in this file

]]--
--[[ ================================================ ]]--

--- Import functions localy for performances reasons
local table = table -- Lua's table module
local ipairs = ipairs -- ipairs function
local pairs = pairs -- pairs function
local ZombRand = ZombRand -- java function

--- import module from ZomboidForge
local ZomboidForge = require "ZomboidForge_module"
local TLOU_infected = require "TLOU_infected"

-- localy initialize mod data
local TLOU_ModData = ModData.getOrCreate("TLOU_Infected")
local function initTLOU_ModData()
	TLOU_ModData = ModData.getOrCreate("TLOU_Infected")
end
Events.OnInitGlobalModData.Remove(initTLOU_ModData)
Events.OnInitGlobalModData.Add(initTLOU_ModData)

-- localy initialize player
local player = getPlayer()
local function initTLOU_OnGameStart(playerIndex, player_init)
	player = getPlayer()
end
Events.OnCreatePlayer.Remove(initTLOU_OnGameStart)
Events.OnCreatePlayer.Add(initTLOU_OnGameStart)


--#region Custom behavior: `DoorOneShot`

-- Manage Bloater strength against structures by making them extra strong.
---@param zombie 		IsoZombie
---@param ZType 		string   	     --Zombie Type ID
ZomboidForge.StrongBloater = function(zombie,ZType,thumped)
	-- check barricades and damage those first if present
	if instanceof(thumped,"BarricadeAble") and thumped:isBarricaded() then
		---@cast thumped BarricadeAble

		local barricade = nil
		-- loop to damage multiple times, it's set so Bloater remove one plank per hit approximatively
		for _ = 1,200 do
			-- need to verify the barricade is not destroyed everytime it's thumped
			barricade = thumped:getBarricadeForCharacter(zombie)
			if not barricade then
				barricade = thumped:getBarricadeOppositeCharacter(zombie)
				if not barricade then break end
			end
			barricade:Thump(zombie)
		end

	-- damage structure getting thumped if no barricades
	else
		local health = nil
		-- need to make a difference between each classes
		-- IsoThumpable is player built structures
		if instanceof(thumped,"IsoThumpable") then
			---@cast thumped IsoThumpable

			health = thumped:getHealth()
			if thumped:isDoor() then
				thumped:setHealth(health-200)
			elseif thumped:isWindow() then
				thumped:destroy()
			else
				thumped:setHealth(health-100)
			end

		-- IsoDoor is map structure
		elseif instanceof(thumped,"IsoDoor") then
			---@cast thumped IsoDoor

			health = thumped:getHealth()
			thumped:setHealth(health-100)

		-- IsoWindow is map structure
		elseif instanceof(thumped,"IsoWindow") then
			---@cast thumped IsoWindow

			thumped:smashWindow()
		end
	end
end

--#endregion