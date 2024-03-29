
--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

This file defines the core of the mod of The Last of Us Infected Fork

]]--
--[[ ================================================ ]]--

--- Import functions localy for performances reasons
local table = table -- Lua's table module
local ipairs = ipairs -- ipairs function
local pairs = pairs -- pairs function
local ZombRand = ZombRand -- java function
local print = print -- print function
local tostring = tostring --tostring function

--- import module from ZomboidForge
local ZomboidForge = require "ZomboidForge_module"

--- setup local functions
ZomboidForge.TLOU_infected = ZomboidForge.TLOU_infected or {}
local timeCheck = 500

--- Create zombie types
ZomboidForge.InitTLOUInfected = function()
	ZomboidForge.TLOU_infected.lootchance = {
		runner = SandboxVars.TLOUZombies.CordycepsSpawnRate_Runner,
		stalker = SandboxVars.TLOUZombies.CordycepsSpawnRate_Stalker,
		clicker = SandboxVars.TLOUZombies.CordycepsSpawnRate_Clicker,
		bloater = SandboxVars.TLOUZombies.CordycepsSpawnRate_Bloater,
	}

	ZomboidForge.TLOU_infected.OnlyUnexplored = SandboxVars.TLOUZombies.OnlyUnexplored
	ZomboidForge.TLOU_infected.WanderAtNight = SandboxVars.TLOUZombies.WanderAtNight
	ZomboidForge.TLOU_infected.MaxDistanceToCheck = SandboxVars.TLOUZombies.MaxDistanceToCheck

    -- RUNNER
	if SandboxVars.TLOUZombies.RunnerSpawn then
		--table.insert(ZomboidForge.ZTypes,
		ZomboidForge.ZTypes.TLOU_Runner =
			{
				-- base informations
				name = "IGUI_TLOU_Runner",
				chance = SandboxVars.TLOUZombies.RunnerChance,
				outfit = {},
				reanimatedPlayer = false,
				skeleton = false,
				hair = {},
				hairColor = {},
				beard = {},
				beardColor = {},

				-- stats
				walktype = 1,
				strength = 2,
				toughness = 2,
				cognition = 3,
				memory = 2,
				sight = SandboxVars.TLOUZombies.RunnerVision,
				hearing = SandboxVars.TLOUZombies.RunnerHearing,
				HP = 1,

				noteeth = false,
				transmission = false,

				-- custom variables
				isRunner = true,

				-- UI
				color = {122, 243, 0,},
				outline = {0, 0, 0,},

				-- attack functions
				funcattack = {},
				funconhit = {},

				-- custom behavior
				onDeath = {},
				customBehavior = {
					"SetRunnerSounds",
				},
			}
		--)
	end

    -- STALKER
	if SandboxVars.TLOUZombies.StalkerSpawn then
		--table.insert(ZomboidForge.ZTypes,
		ZomboidForge.ZTypes.TLOU_Stalker =
			{
				-- base informations
				name = "IGUI_TLOU_Stalker",
				chance = SandboxVars.TLOUZombies.StalkerChance,
				outfit = {},
				reanimatedPlayer = false,
				skeleton = false,
				hair = {},
				hairColor = {},
				beard = {
					"",
				},
				beardColor = {},

				-- stats
				walktype = 1,
				strength = 1,
				toughness = 2,
				cognition = 3,
				memory = 3,
				sight = SandboxVars.TLOUZombies.StalkerVision,
				hearing = SandboxVars.TLOUZombies.StalkerHearing,
				HP = 1,

				noteeth = false,
				transmission = false,

				-- custom variables
				isStalker = true,

				-- UI
				color = {230, 230, 0,},
				outline = {0, 0, 0,},

				-- attack functions
				funcattack = {},
				funconhit = {},

				-- custom behavior
				onDeath = {},
				customBehavior = {
					"SetStalkerSounds",
					"RemoveBandages",
				},
			}
		--)
	end

    -- CLICKER
	if SandboxVars.TLOUZombies.ClickerSpawn then
		ZomboidForge.ZTypes.TLOU_Clicker =
		--table.insert(ZomboidForge.ZTypes,
			{
				-- base informations
				name = "IGUI_TLOU_Clicker",
				chance = SandboxVars.TLOUZombies.ClickerChance,
				outfit = {},
				reanimatedPlayer = false,
				skeleton = false,
				hair = {
					male = {
						"",
					},
					female = {
						"",
					},
				},
				hairColor = {
					ImmutableColor.new(Color.new(0.70, 0.70, 0.70, 1)),
				},
				beard = {
					"",
				},
				beardColor = {},
				animationVariable = "isClicker",

				-- stats
				walktype = 2,
				strength = 1,
				toughness = 1,
				cognition = 3,
				memory = 2,
				sight = 3,
				hearing = SandboxVars.TLOUZombies.ClickerHearing,
				HP = SandboxVars.TLOUZombies.ClickerHealth,

				noteeth = false,
				transmission = false,

				-- custom variables
				isClicker = true,

				-- UI
				color = {218, 109, 0,},
				outline = {0, 0, 0,},

				-- attack functions
				funcattack = {
					"ClickerAttack",
				},
				funconhit = {
					"ClickerHit",
				},

				-- custom behavior
				onDeath = {
					"OnClickerDeath",
				},
				customBehavior = {
					"SetClickerClothing",
					"SetClickerSounds",
					"ClickerAgro",
					"RemoveBandages",
				},
			}
		--)
	end

    -- BLOATER
	if SandboxVars.TLOUZombies.BloaterSpawn then
		--table.insert(ZomboidForge.ZTypes,
		ZomboidForge.ZTypes.TLOU_Bloater =
			{
				-- base informations
				name = "IGUI_TLOU_Bloater",
				chance = SandboxVars.TLOUZombies.BloaterChance,
				outfit = {
					"Bloater",
				},
				reanimatedPlayer = false,
				skeleton = false,
				hair = {},
				hairColor = {},
				beard = {},
				beardColor = {},

				-- stats
				walktype = 2,
				strength = 1,
				toughness = 1,
				cognition = 3,
				memory = 2,
				sight = 3,
				hearing = SandboxVars.TLOUZombies.BloaterHearing,
				HP = SandboxVars.TLOUZombies.BloaterHealth,

				noteeth = false,
				transmission = false,

				-- custom variables
				isBloater = true,

				-- UI
				color = {205, 0, 0,},
				outline = {0, 0, 0,},

				-- attack functions
				funcattack = {
					"BloaterAttack",
				},
				funconhit = {
					"BloaterHit",
				},
				customDamage = "BloaterDamage",

				-- custom behavior
				onDeath = {},
				customBehavior = {
					"SetBloaterSounds",
					"RemoveBandages",
				},
			}
		--)
	end

	if SandboxVars.TLOUZombies.HideIndoors then
		table.insert(ZomboidForge.ZTypes.TLOU_Stalker.customBehavior,
			"HideIndoors"
		)

		table.insert(ZomboidForge.ZTypes.TLOU_Clicker.customBehavior,
			"HideIndoors"
		)

		table.insert(ZomboidForge.ZTypes.TLOU_Bloater.customBehavior,
			"HideIndoors"
		)
	end

	if SandboxVars.TLOUZombies.StrongBloater then
		table.insert(ZomboidForge.ZTypes.TLOU_Bloater.customBehavior,
			"StrongBloater"
		)
	end

	if getActivatedMods():contains("BB_SporeZones") and SandboxVars.TLOU_Overhaul.CordycepsSpawn then
		table.insert(ZomboidForge.ZTypes.TLOU_Runner.onDeath,
			"OnInfectedDeath_cordyceps"
		)

		table.insert(ZomboidForge.ZTypes.TLOU_Stalker.onDeath,
			"OnInfectedDeath_cordyceps"
		)

		table.insert(ZomboidForge.ZTypes.TLOU_Clicker.onDeath,
			"OnInfectedDeath_cordyceps"
		)

		table.insert(ZomboidForge.ZTypes.TLOU_Bloater.onDeath,
			"OnInfectedDeath_cordyceps"
		)
	end
end

--#region Attack and Onhit functions

-- clicker attacks a player
function ZomboidForge.ClickerAttack(player,zombie)
	if player and player:isAlive() then
		--clicker grabs player
		if SandboxVars.TLOUZombies.GrabbyClickers and not player:isGodMod() then
			player:setSlowFactor(1)
			player:setSlowTimer(1)
		end

		-- kill player if oneshot clickers
		if SandboxVars.TLOUZombies.OneShotClickers then 
			if player:hasHitReaction() and not player:isGodMod() or instanceof(player, "IsoZombie") then
				--player:setDeathDragDown(true)
				player:Kill(zombie)
			end
		end
	end
end

-- bloater attacks a player
function ZomboidForge.BloaterAttack(player,zombie)
	if player and player:isAlive() then
		-- bloater grabs player
		if not player:isGodMod() then
			player:setSlowFactor(1)
			player:setSlowTimer(1)
		end

		-- kill player
		if player:hasHitReaction() and not player:isGodMod() then
			player:Kill(zombie)
		end
	end
end

-- player attacked a clicker
function ZomboidForge.ClickerHit(player, zombie, HandWeapon, damage)
	if SandboxVars.TLOUZombies.NoPushClickers then
		if HandWeapon:getFullType() == "Base.BareHands" then
			zombie:setOnlyJawStab(true)
		else
			zombie:setOnlyJawStab(false)
		end
	end
end

-- player attacked a bloater
function ZomboidForge.BloaterHit(player, zombie, HandWeapon, damage)
	-- can't be pushed
	if not zombie:isOnlyJawStab() then
		zombie:setOnlyJawStab(true)
	end

	--zombie:setHealth()
	if not zombie:getHitTime() == 0 then
		zombie:setHitTime(0)
	end
end

-- set damage to bloater from player
function ZomboidForge.BloaterDamage(player, zombie, HandWeapon, damage)
	-- maximum damage output
	if damage >= 3 then
		damage = 3
	end

	-- if Zombie is on fire, deal more damage even past max damage output
	if zombie:isOnFire() then
		damage = damage * 3
	end
	return damage
end
--#endregion

-- custom targeting of Clickers to make them attack other zombies when blind
--[[
	
if storeZombie and storeZombie ~= zombie and zombie:getTarget() ~= storeZombie then
	zombie:setTarget(storeZombie)
	zombie:setAttackedBy(storeZombie)
	print("setting target")
end
storeZombie = zombie
zombie:addLineChatElement(tostring(zombie:getTarget()))
]]

--- Custom behavior

--#region Custom behavior: `OnDeath loot`

-- Replace fungi hat clothing with fungi hat food type on a `Clicker`'s death.
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
---@param ZType integer     --Zombie Type ID
ZomboidForge.OnClickerDeath = function(zombie,ZType)
	-- add fungi hat food type to inventory
	local inventory = zombie:getInventory()
	inventory:AddItems("Hat_Fungi_Loot",1)
	print("done")
end

-- Add cordyceps mushrooms from Braven's Cordyceps Spore Zones when activated to various infected loot.
-- Purely for aesthetic and immersion.
-- Cordyceps loot count :
--
-- 		`Runner = 1 to 3`
-- 		`Stalker = 1 to 5`
-- 		`Clicker = 3 to 10`
-- 		`Bloater = 5 to 15`
--
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
---@param ZType integer     --Zombie Type ID
ZomboidForge.OnInfectedDeath_cordyceps = function(zombie,ZType)
	-- add fungi hat food type to inventory
	local inventory = zombie:getInventory()
	local ZombieTable = ZomboidForge.ZTypes[ZType]

	-- roll to inventory
	local rand = ZombRand(1,100)
	local lootchance = ZomboidForge.TLOU_infected.lootchance
	if ZombieTable.isRunner and lootchance.runner >= rand then
		inventory:AddItems("Cordyceps", ZombRand(1,3))
	elseif ZombieTable.isStalker and lootchance.stalker >= rand then
		inventory:AddItems("Cordyceps", ZombRand(1,5))
	elseif ZombieTable.isClicker and lootchance.clicker >= rand then
		inventory:AddItems("Cordyceps", ZombRand(3,10))
	elseif ZombieTable.isBloater and lootchance.bloater >= rand then
		inventory:AddItems("Cordyceps", ZombRand(5,15))
	end
end
--#endregion

--#region Custom behavior: `RemoveBandages`

-- Remove visual bandages on Zombies who have some, else skip.
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
---@param ZType integer     --Zombie Type ID
ZomboidForge.RemoveBandages = function(zombie,ZType)
	-- Remove bandages
	local bodyVisuals = zombie:getHumanVisual():getBodyVisuals()
	if bodyVisuals and bodyVisuals:size() > 0 then
		zombie:getHumanVisual():getBodyVisuals():clear()
		zombie:resetModel()
	end
end

--#endregion

--#region Custom behavior: `SetInfectedSounds`

-- For debug purposes, allows to check vocals of a zombie.
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
ZomboidForge.VerifyEmitter = function(zombie)
	local stringZ = "Emitters:"
	stringZ = stringZ.."\nMaleA = "..tostring(zombie:getEmitter():isPlaying("Zombie/Voice/MaleA"))
	stringZ = stringZ.."\nFemaleA = "..tostring(zombie:getEmitter():isPlaying("Zombie/Voice/FemaleA"))
	stringZ = stringZ.."\nMaleB = "..tostring(zombie:getEmitter():isPlaying("Zombie/Voice/MaleB"))
	stringZ = stringZ.."\nFemaleB = "..tostring(zombie:getEmitter():isPlaying("Zombie/Voice/FemaleB"))
	stringZ = stringZ.."\nMaleC = "..tostring(zombie:getEmitter():isPlaying("Zombie/Voice/MaleC"))
	stringZ = stringZ.."\nFemaleC = "..tostring(zombie:getEmitter():isPlaying("Zombie/Voice/FemaleC"))
	return stringZ
end

-- Set `Runner` sounds.
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
---@param ZType integer     --Zombie Type ID
ZomboidForge.SetRunnerSounds = function(zombie,ZType)
	if not zombie:getEmitter():isPlaying("Zombie/Voice/MaleA") and not zombie:isFemale()
	or not zombie:getEmitter():isPlaying("Zombie/Voice/FemaleA") and zombie:isFemale() then
		zombie:setAge(-2)
		zombie:getEmitter():stopAll()
		if zombie:isFemale() then
			zombie:getEmitter():playVocals("Zombie/Voice/FemaleA")
		else 
			zombie:getEmitter():playVocals("Zombie/Voice/MaleA")
		end
	end
end

-- Set `Stalker` sounds.
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
---@param ZType integer     --Zombie Type ID
ZomboidForge.SetStalkerSounds = function(zombie,ZType)
	if not zombie:getEmitter():isPlaying("Zombie/Voice/MaleB") and not zombie:isFemale()
	or not zombie:getEmitter():isPlaying("Zombie/Voice/FemaleB") and zombie:isFemale() then
		zombie:setAge(-2)
		zombie:getEmitter():stopAll()
		if zombie:isFemale() then
			zombie:getEmitter():playVocals("Zombie/Voice/FemaleB")
		else
			zombie:getEmitter():playVocals("Zombie/Voice/MaleB")
		end
	end
end

-- Set `Clicker` sounds.
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
---@param ZType integer     --Zombie Type ID
ZomboidForge.SetClickerSounds = function(zombie,ZType)
	if not zombie:getEmitter():isPlaying("Zombie/Voice/FemaleC")then
		zombie:setAge(-2)
		zombie:getEmitter():stopAll()
		zombie:getEmitter():playVocals("Zombie/Voice/FemaleC")
	end
end

-- Set `Bloater` sounds.
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
---@param ZType integer     --Zombie Type ID
ZomboidForge.SetBloaterSounds = function(zombie,ZType)
	if not zombie:getEmitter():isPlaying("Zombie/Voice/MaleC") then
		zombie:setAge(-2)
		zombie:getEmitter():stopAll()
		zombie:getEmitter():playVocals("Zombie/Voice/MaleC")
	end
end

--#endregion

--#region Custom behavior: `SetClickerClothing`

-- clothing priority to replace
ZomboidForge.TLOU_infected.ClothingPriority = {
	["Hat"] = 1,
	["Mask"] = 2,
	["Eyes"] = 3,
	["LeftEye"] = 4,
	["RightEye"] = 5,
	["Nose"] = 6,
	["BellyButton"] = 7,
	["Right_MiddleFinge"] = 8,
	["Left_MiddleFinger"] = 9,
	["Right_RingFinger"] = 10,
	["Left_RingFinger"] = 11,
	["Ears"] = 12,
	["EarTop"] = 13,
	["Necklace"] = 14,
	["Necklace_Long"] = 15,
	["UnderwearTop"] = 16,
	["UnderwearBottom"] = 17,
	["UnderwearExtra1"] = 18,
	["UnderwearExtra2"] = 19,
	["Underwear"] = 20,
	["Socks"] = 21,
	["RightWrist"] = 22,
	["LeftWrist"] = 23,
	["Tail"] = 24,

	["Hands"] = 25,
	["Belt"] = 26,
	["BeltExtra"] = 27,
	["AmmoStrap"] = 28,
	["Scarf"] = 29,
	["Neck"] = 30,
	["TorsoExtra"] = 31,
	["TankTop"] = 32,
	["Tshirt"] = 33,
	["ShortSleeveShirt"] = 34,
	["Shirt"] = 35,
	["Sweater"] = 36,
	["TorsoExtraVest"] = 37,
	["Pants"] = 38,
	["Skirt"] = 39,
	["Torso1Legs1"] = 40,
	["Legs1"] = 41,
	["Shoes"] = 42,
	["Jacket"] = 43,
}

-- Set clicker clothing by visually replacing one of its clothing based on the priority list of clothings to replace.
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
---@param ZType integer     --Zombie Type ID
ZomboidForge.SetClickerClothing = function(zombie,ZType)
	-- get zombie info
	local trueID = ZomboidForge.pID(zombie)
	ZomboidForge.NonPersistentZData[trueID] = ZomboidForge.NonPersistentZData[trueID] or {}
	ZomboidForge.NonPersistentZData[trueID].TLOU_infected = ZomboidForge.NonPersistentZData[trueID].TLOU_infected or {}

	-- if already has hat fungi then skip
	local hasHat_Fungi = ZomboidForge.NonPersistentZData[trueID].TLOU_infected.hasHat_Fungi
	if hasHat_Fungi then return end

	-- update lure counter
	local clothingCounter = ZomboidForge.NonPersistentZData[trueID].TLOU_infected.ClothingCounter or timeCheck
	if clothingCounter and clothingCounter >= 0 then
		ZomboidForge.NonPersistentZData[trueID].TLOU_infected.ClothingCounter = clothingCounter - 1
		return
	end
	ZomboidForge.NonPersistentZData[trueID].TLOU_infected.ClothingCounter = timeCheck

	-- get clothing visuals from zombie
	local visual = zombie:getItemVisuals()
	if not visual then return end

	-- scroll through every clothing and replace it
	if visual:size() > 0 then
		local priority = 100
		local itemReset = nil
		for i = 0, visual:size()-1 do
			local item = visual:get(i)
			if not item then
				break
			end
			local bodyLocation = item:getScriptItem():getBodyLocation()
			local priorityTest = ZomboidForge.TLOU_infected.ClothingPriority[bodyLocation]
			if item:getItemType() == "Base.Hat_Fungi" then
				hasHat_Fungi = true
				break
			elseif priorityTest and priorityTest < priority then
				-- if not, then add one to the item
				priority = priorityTest
				itemReset = item
				hasHat_Fungi = false
			end
		end
		if not hasHat_Fungi and itemReset then
			itemReset:setItemType("Base.Hat_Fungi")
			itemReset:setClothingItemName("Hat_Fungi")
			zombie:resetModel()
		end

	-- if no visuals were found then add a visual item which is the Hat Fungi
	else
		local itemVisual = ItemVisual.new()
		itemVisual:setItemType("Base.Hat_Fungi")
		itemVisual:setClothingItemName("Hat_Fungi")
		visual:add(itemVisual)

		zombie:resetModel()
	end

	-- update multiCheck counter
	local multiCheck = ZomboidForge.NonPersistentZData[trueID].TLOU_infected.multiCheck or 0
	if multiCheck >= 10 then
		-- stop checking for this zombie
		ZomboidForge.NonPersistentZData[trueID].TLOU_infected.hasHat_Fungi = hasHat_Fungi
		ZomboidForge.NonPersistentZData[trueID].TLOU_infected.multiCheck = nil
	else
		-- increment multiCheck counter
		multiCheck = multiCheck + 1
		ZomboidForge.NonPersistentZData[trueID].TLOU_infected.multiCheck = multiCheck
	end
end

--#endregion

--#region Custom behavior: `HideIndoors`

-- Main function to handle `Zombie` behavior to go hide inside the closest building or wander during night.
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
---@param ZType integer     --Zombie Type ID
ZomboidForge.HideIndoors = function(zombie,ZType)
	-- if zombie is already in building, completely skip
	if zombie:getBuilding() then return end

	-- ignore if zombie has target
	if zombie:getTarget() then return end

	-- get zombie pID and info
	local trueID = ZomboidForge.pID(zombie)
	ZomboidForge.NonPersistentZData[trueID].TLOU_infected = ZomboidForge.NonPersistentZData[trueID].TLOU_infected or {}

	-- update lure counter
	local lureCounter = ZomboidForge.NonPersistentZData[trueID].TLOU_infected.LureCounter
	if lureCounter and lureCounter >= 0 then
		ZomboidForge.NonPersistentZData[trueID].TLOU_infected.LureCounter = lureCounter - 1
		return
	elseif not lureCounter then
		ZomboidForge.NonPersistentZData[trueID].TLOU_infected.LureCounter = timeCheck
		return
	end
	ZomboidForge.NonPersistentZData[trueID].TLOU_infected.LureCounter = timeCheck

	-- lure zombie either to a building or make it wander if it's daytime
	ZomboidForge.TLOU_infected.LureZombie(zombie)
end

-- Lure `Zombie` to the building during daytime or make it wander around during night time.
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
ZomboidForge.TLOU_infected.LureZombie = function(zombie)
	local TLOU_ModData = ModData.getOrCreate("TLOU_Infected")
    if TLOU_ModData.IsDay or not ZomboidForge.TLOU_infected.WanderAtNight then
		local sourcesq = zombie:getCurrentSquare()
		local squareMoveTo = ZomboidForge.TLOU_infected.GetClosestBuilding(sourcesq)
		if not squareMoveTo then return end
		zombie:pathToSound(squareMoveTo:getX(), squareMoveTo:getY() ,squareMoveTo:getZ())
    else
		local maxDistance = ZomboidForge.TLOU_infected.MaxDistanceToCheck
		local x = zombie:getX() + ZombRand(10,maxDistance) * ZomboidForge.TLOU_infected.CoinFlip()
		local y = zombie:getY() + ZombRand(10,maxDistance) * ZomboidForge.TLOU_infected.CoinFlip()
        zombie:pathToSound(x, y ,0)
    end
end

-- Retrieves the ID of a chunk, from it's coordinates `wx` and `wy`
---@param chunk IsoChunk
---@return string chunkID
ZomboidForge.TLOU_infected.GetChunkID = function(chunk)
	return tostring(chunk.wx).."x"..tostring(chunk.wy)
end

-- Coin flips either `1` or `-1`
---@return integer coinFlip
ZomboidForge.TLOU_infected.CoinFlip = function()
    local randomNumber = ZombRand(2)

    if randomNumber == 0 then
        return -1
    else
        return 1
    end
end

-- Lists to allow easier writing of the code checking buildings
ZomboidForge.TLOU_infected.ChunkCheck = {}
ZomboidForge.TLOU_infected.ChunkCheck.FirstCheck = {
	{1,0},
	{-1,0},
	{0,1},
	{0,-1},
	{1,1},
	{1,-1},
	{-1,1},
	{-1,-1},
}
ZomboidForge.TLOU_infected.ChunkCheck.SecondCheck = {
	{1,1},
	{1,-1},
	{-1,1},
	{1,-1},
}

-- Determines the closest square within a building.
-- Checks in spiral around the original square `sourcesq` and stops when the closest building within
-- a ring of `i` chunk size (up to `maxChunk` size) is found.
---@param sourcesq IsoGridSquare
---@return IsoGridSquare|nil closestSquare
ZomboidForge.TLOU_infected.GetClosestBuilding = function(sourcesq)
	-- skip if no buildings available
	local TLOU_ModData = ModData.getOrCreate("TLOU_Infected")
	if not sourcesq or not TLOU_ModData.BuildingList then return end

	-- initialize data checks
	local closestDist = 100000
	local closestSquare = nil

	-- get coordinates of sourcesq to check distances
	local x_sourcesq = sourcesq:getX()
	local y_sourcesq = sourcesq:getY()

	-- get original chunk of sourcesq and it's data
	local chunk_origin = sourcesq:getChunk()
	local chunkID_origin = ZomboidForge.TLOU_infected.GetChunkID(chunk_origin)
	local wx_origin = chunk_origin.wx
	local wy_origin = chunk_origin.wy

	-- data to retrieve chunkID by calculating wx and wy positions
	local wx = nil
	local wy = nil
	local chunkID = nil

	-- check if building is in central chunk then stops everything there if detected
	closestDist, closestSquare = ZomboidForge.TLOU_infected.CheckBuildingDistance(chunkID_origin,closestDist,closestSquare,x_sourcesq,y_sourcesq)
	if closestSquare then return closestSquare end

	-- iterates through max distance
	local maxChunk = ZomboidForge.TLOU_infected.MaxDistanceToCheck/10
	for i = 1,maxChunk do
		-- check main lines x and y chunks
		for _,j in ipairs(ZomboidForge.TLOU_infected.ChunkCheck.FirstCheck) do
			wx = wx_origin + i * j[1]
			wy = wy_origin + i * j[2]
			chunkID = tostring(wx).."x"..tostring(wy)
			closestDist, closestSquare = ZomboidForge.TLOU_infected.CheckBuildingDistance(chunkID,closestDist,closestSquare,x_sourcesq,y_sourcesq)
		end
		-- check side chunks
		for _,j in ipairs(ZomboidForge.TLOU_infected.ChunkCheck.SecondCheck) do
			for k = 1,i do
				wx = wx_origin + j[1] * k
				wy = wy_origin + j[2] * i
				chunkID = tostring(wx).."x"..tostring(wy)
				closestDist, closestSquare = ZomboidForge.TLOU_infected.CheckBuildingDistance(chunkID,closestDist,closestSquare,x_sourcesq,y_sourcesq)

				wx = wx_origin + j[1] * i
				wy = wy_origin + j[2] * k
				chunkID = tostring(wx).."x"..tostring(wy)
				closestDist, closestSquare = ZomboidForge.TLOU_infected.CheckBuildingDistance(chunkID,closestDist,closestSquare,x_sourcesq,y_sourcesq)
			end
		end

		-- stops early if found, no point in going further since it will look at chunks further
		if closestSquare then return closestSquare end
	end
	return closestSquare
end

-- Check building distance from `sourcesq` position and returns closest square and distance from `sourcesq`.
---@param chunkID string
---@param closestDist double|nil
---@param closestSquare IsoGridSquare|nil
---@param x_sourcesq double
---@param y_sourcesq double
---@return double|nil closestDist
---@return IsoGridSquare|nil closestSquare
ZomboidForge.TLOU_infected.CheckBuildingDistance = function(chunkID,closestDist,closestSquare,x_sourcesq,y_sourcesq)
	local TLOU_ModData = ModData.getOrCreate("TLOU_Infected")
	local squareCheck = nil
	local distance = nil
	local building = nil

	if TLOU_ModData.BuildingList[chunkID] then
		for _,buildingData in pairs(TLOU_ModData.BuildingList[chunkID]) do
			local square = getSquare(buildingData[1],buildingData[2],0)
			if not square then return closestDist, closestSquare end
			building = square:getBuilding()
			squareCheck = building:getRandomRoom():getRandomFreeSquare()
			if not squareCheck then return closestDist, closestSquare end
			distance = IsoUtils.DistanceTo(x_sourcesq, y_sourcesq, squareCheck:getX() , squareCheck:getY())

			-- check if distance < closestDist, if true then next test
			-- if OnlyUnexplored is false, then ignore the rest and pass
			-- if OnlyUnexplored is true, check if whole building is explored, if true then don't pass, if false then pass
			if distance < closestDist and
			not (ZomboidForge.TLOU_infected.OnlyUnexplored and (not ZomboidForge.TLOU_infected.OnlyUnexplored or not building:isAllExplored()))
			then
				closestDist = distance
				closestSquare = squareCheck
			end
		end
	end
	return closestDist, closestSquare
end

-- Checks if it's daytime by taking into account the seasons and updates the `IsDay` check.
ZomboidForge.TLOU_infected.IsDay = function()
	-- get gametime
	local gametime = GameTime:getInstance();
	local month = gametime:getMonth()
	local currentHour = math.floor(gametime:getTimeOfDay())

	-- check season
	local season = nil
	if month == 2 or month == 3 or month == 4 then
		season = "Spring";
	elseif month == 5 or month == 6 or month == 7 then
		season = "Summer";
	elseif month == 8 or month == 9 or month == 10 then
		season = "Autumn";
	elseif month == 11 or month == 12 or month == 1 then
		season = "Winter";
	end

	-- check if it's day based on season and current time
	local IsDay = false
	if (season == "Spring" and currentHour >= 6 and currentHour <= 21) or
    (season == "Summer" and currentHour >= 6 and currentHour <= 22) or
    (season == "Autumn" and currentHour >= 6 and currentHour <= 21) or
    (season == "Winter" and currentHour >= 8 and currentHour <= 17) then
		IsDay = true
	end

	-- update IsDay check
	local TLOU_ModData = ModData.getOrCreate("TLOU_Infected")
	TLOU_ModData.IsDay = IsDay
end

-- Adds detected buildings to the list of available buildings in a chunk.
ZomboidForge.TLOU_infected.AddBuildingList = function(square)
	-- get moddata and check if BuildingList exists, else initialize it
	local TLOU_ModData = ModData.getOrCreate("TLOU_Infected")
	TLOU_ModData.BuildingList = TLOU_ModData.BuildingList or {}

	-- check if square is in building
	local building = square:getBuilding()
	if not building then return end

	-- get building ID via it's KeyID which is persistent
	local buildingID = building:getDef():getKeyId()

	-- get chunk ID
	local chunk = square:getChunk()
	local chunkID = ZomboidForge.TLOU_infected.GetChunkID(chunk)

	-- check if building is already in BuildingList, if not add its coordinates to the list
	TLOU_ModData.BuildingList[chunkID] = TLOU_ModData.BuildingList[chunkID] or {}
	if not TLOU_ModData.BuildingList[chunkID][buildingID] then
		local room = building:getRandomRoom()
		local squareBuilding = room:getRandomFreeSquare()
		if squareBuilding then
			TLOU_ModData.BuildingList[chunkID][buildingID] = {squareBuilding:getX(),squareBuilding:getY()}
		end
	end
end

--#endregion

--#region Custom behavior: `DoorOneShot`

-- Manage Bloater strength against structures by making them extra strong.
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
---@param ZType integer     --Zombie Type ID
ZomboidForge.StrongBloater = function(zombie,ZType)
	-- run code if infected has thumping target
	local thumped = zombie:getThumpTarget()
	if not thumped then return end

	-- get zombie info
	local trueID = ZomboidForge.pID(zombie)
	local TLOU_ModData = ModData.getOrCreate("TLOU_Infected")
	TLOU_ModData.Infected = TLOU_ModData.Infected or {}
	TLOU_ModData.Infected[trueID] = TLOU_ModData.Infected[trueID] or {}

	-- update thumped only if infected is thumping
	local thumpCheck = TLOU_ModData.Infected[trueID].thumpCheck
	if thumpCheck == zombie:getTimeThumping() then
		return
	elseif zombie:getTimeThumping() == 0 then
		return
	end
	TLOU_ModData.Infected[trueID].thumpCheck = zombie:getTimeThumping()

	-- check barricades damage those if present
	local barricade = nil
	if thumped:isBarricaded() then
		for i = 1,200 do
			barricade = thumped:getBarricadeForCharacter(zombie)
			if not barricade then
				barricade = thumped:getBarricadeOppositeCharacter(zombie)
				if not barricade then break end
			end
			barricade:Thump(zombie)
		end

	-- update health
	else
		local health = nil
		-- need to make a difference between each classes
		-- IsoThumpable is player built
		if instanceof(thumped,"IsoThumpable") then
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
			health = thumped:getHealth()
			thumped:setHealth(health-100)

		-- IsoWindow is map structure
		elseif instanceof(thumped,"IsoWindow") then
			thumped:smashWindow()
		end
	end
end
--#endregion

--#region Custom behavior: `ClickerAgro`

-- Manage Clicker agro to change their animation when 
-- they run after a player.
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
---@param ZType integer     --Zombie Type ID
ZomboidForge.ClickerAgro = function(zombie,ZType)
	local target = zombie:getTarget()
	if target and not zombie:getVariableBoolean("ClickerAgro") then
		zombie:setVariable("ClickerAgro",'true')
		if isClient() then
			sendClientCommand('AnimationHandler', 'SetAnimationVariable', {animationVariable = "ClickerAgro", zombie = zombie:getOnlineID(), state = true})
		end
	elseif not target and zombie:getVariableBoolean("ClickerAgro") then
		zombie:setVariable("ClickerAgro",'false')
		if isClient() then
			sendClientCommand('AnimationHandler', 'SetAnimationVariable', {animationVariable = "ClickerAgro", zombie = zombie:getOnlineID(), state = false})
		end
	end
end
--#endregion
