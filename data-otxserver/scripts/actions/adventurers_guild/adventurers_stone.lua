local config = {
	enableTemples = true,
	enableDepots = false,

	Temples = {
		{ fromPos = Position(157, 385, 6), toPos = Position(166, 390, 6), townId = TOWNS_LIST.RHYVES },
		{ fromPos = Position(237, 426, 12), toPos = Position(246, 436, 12), townId = TOWNS_LIST.VARAK },
		{ fromPos = Position(491, 166, 7), toPos = Position(503, 177, 7), townId = TOWNS_LIST.JORVIK },
		{ fromPos = Position(235, 562, 7), toPos = Position(245, 569, 7), townId = TOWNS_LIST.SAUND },
	},

	Depots = {
		{ fromPos = Position(103, 357, 6), toPos = Position(111, 367, 6), townId = TOWNS_LIST.RHYVES },
		{ fromPos = Position(249, 459, 12), toPos = Position(254, 466, 12), townId = TOWNS_LIST.VARAK },
		{ fromPos = Position(391, 197, 7), toPos = Position(411, 209, 7), townId = TOWNS_LIST.JORVIK },
		{ fromPos = Position(222, 555, 6), toPos = Position(232, 562, 6), townId = TOWNS_LIST.SAUND },
	},
}

local adventurersStone = Action()

function adventurersStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local playerPos, allowed, townId = player:getPosition(), false
	if config.enableTemples then
		for _, temple in ipairs(config.Temples) do
			if isInRangeIgnoreZ(playerPos, temple.fromPos, temple.toPos) then
				allowed, townId = true, temple.townId
				break
			end
		end
	end

	if config.enableDepots then
		for _, depot in ipairs(config.Depots) do
			if isInRangeIgnoreZ(playerPos, depot.fromPos, depot.toPos) then
				allowed, townId = true, depot.townId
				break
			end
		end
	end

	if not allowed then
		local enabledLocations = {}
		if config.enableTemples then
			table.insert(enabledLocations, "temple")
		end
		if config.enableDepots then
			table.insert(enabledLocations, "depot")
		end
		local message = "Try to move more to the center of a " .. table.concat(enabledLocations, " or ") .. " to use the spiritual energy for a teleport."
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
		return true
	end

	player:setStorageValue(Storage.AdventurersGuild.Stone, townId)
	playerPos:sendMagicEffect(CONST_ME_TELEPORT)

	local destination = Position(32210, 32300, 6)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

adventurersStone:id(16277)
adventurersStone:register()
