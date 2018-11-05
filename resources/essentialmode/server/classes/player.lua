-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

-- Constructor
Player = {}
Player.__index = Player

-- Meta table for users
setmetatable(Player, {
	__call = function(self, source, permission_level, money, job, vehicle, weapon, weapon2, weapon3, model, identifier, group)
		local pl = {}

		pl.source = source
		pl.permission_level = permission_level
		pl.money = money
		pl.job = job
		pl.vehicle = vehicle
		pl.weapon = weapon
		pl.weapon2 = weapon2
		pl.weapon3 = weapon3
		pl.model = model
		pl.identifier = identifier
		pl.group = group
		pl.coords = {x = 0.0, y = 0.0, z = 0.0}
		pl.session = {}

		return setmetatable(pl, Player)
	end
})

-- Getting permissions
function Player:getPermissions()
	return self.permission_level
end

-- Setting them
function Player:setPermissions(p)
	TriggerEvent("es:setPlayerData", self.source, "permission_level", p, function(response, success)
		self.permission_level = p
	end)
end

-- No need to ever call this (No, it doesn't teleport the player)
function Player:setCoords(x, y, z)
	self.coords.x, self.coords.y, self.coords.z = x, y, z
end

-- Kicks a player with specified reason
function Player:kick(reason)
	DropPlayer(self.source, reason)
end

-- get player money
function Player:getMoney()

	return self.money

end

-- Sets the player money (required to call this from now)
function Player:setMoney(m)
	local prevMoney = self.money
	local newMoney : double = m

	self.money = m

	if((prevMoney - newMoney) < 0)then
		TriggerClientEvent("es:addedMoney", self.source, math.abs(prevMoney - newMoney))
	else
		TriggerClientEvent("es:removedMoney", self.source, math.abs(prevMoney - newMoney))
	end

	TriggerClientEvent('es:activateMoney', self.source , self.money)
end

-- Adds to player money (required to call this from now)
function Player:addMoney(m)
	local newMoney : double = self.money + m

	self.money = newMoney

	TriggerClientEvent("es:addedMoney", self.source, m)
	TriggerClientEvent('es:activateMoney', self.source , self.money)
end

-- Removes from player money (required to call this from now)
function Player:removeMoney(m)
	local newMoney : double = self.money - m

	self.money = newMoney

	TriggerClientEvent("es:removedMoney", self.source, m)
	TriggerClientEvent('es:activateMoney', self.source , self.money)
end

-- Player session variables
function Player:setSessionVar(key, value)
	self.session[key] = value
end

function Player:getSessionVar(key)
	return self.session[key]
end

-- Player job
function Player:setJob(title)
	self.job = title;
end

function Player:getJob()
	return self.job
end

-- Player vehicle
function Player:setVehicle(hash)
	self.vehicle = hash;
end

function Player:getVehicle()
	return self.vehicle
end

-- Player weapon
function Player:setWeapon(hash)
	self.weapon = hash;
end

function Player:getWeapon()
	return self.weapon
end

-- Player weapon2
function Player:setWeapon2(hash)
	self.weapon2 = hash;
end

function Player:getWeapon2()
	return self.weapon2
end

-- Player weapon3
function Player:setWeapon3(hash)
	self.weapon3 = hash;
end

function Player:getWeapon3()
	return self.weapon3
end

-- Player model
function Player:setModel(model)
	self.model = model;
end

function Player:getModel()
	return self.model
end