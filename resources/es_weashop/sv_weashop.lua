-- Loading MySQL Class
require "resources/mysql-async/lib/MySQL"

local max_number_weapons = 9999 --maximum number of weapons that the player can buy. Weapons given at spawn doesn't count.
local cost_ratio = 50 --Ratio for withdrawing the weapons. This is price/cost_ratio = cost.

RegisterServerEvent('CheckMoneyForWea')
AddEventHandler('CheckMoneyForWea', function(weapon,price)
	TriggerEvent('es:getPlayerFromId', source, function(user)

		if (tonumber(user.money) >= tonumber(price)) then
			local player = user.identifier
			local nb_weapon = 0
			local result = MySQL.Sync.fetchAll("SELECT * FROM user_weapons WHERE identifier = @username",{['@username'] = player})
			if result then
				for k,v in ipairs(result) do
					nb_weapon = nb_weapon + 1
				end
			end
			-- print(nb_weapon)
			if (tonumber(max_number_weapons) > tonumber(nb_weapon)) then
				-- Pay the shop (price)
				user:removeMoney((price))
				MySQL.Async.execute("INSERT INTO user_weapons (identifier,weapon_model,withdraw_cost) VALUES ('@username','@weapon','@cost')",
				{['@username'] = player, ['@weapon'] = weapon, ['@cost'] = (price)/cost_ratio})
				-- Trigger some client stuff
				TriggerClientEvent("FinishMoneyCheckForWea",source)
				TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_ROBERTO", 1, "Roberto", false, "Your purchase went through")
			else
				TriggerClientEvent('ToManyWeapons',source)
				TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_ROBERTO", 1, "Roberto", false, "You reached the limit of weapons. (max: "..max_number_weapons..")\n")
			end
		else
			-- Inform the player that he needs more money
			TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_ROBERTO", 1, "Roberto", false, "You cannot afford this")
		end
	end)
end)

RegisterServerEvent("weaponshop:playerSpawned")
AddEventHandler("weaponshop:playerSpawned", function(spawn)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('weaponshop:GiveWeaponsToPlayer', source)
	end)
end)

RegisterServerEvent("weaponshop:GiveWeaponsToPlayer")
AddEventHandler("weaponshop:GiveWeaponsToPlayer", function(player)
	TriggerEvent('es:getPlayerFromId', player, function(user)
		local playerID = user.identifier
		local delay = nil
			
		local result = MySQL.Sync.fetchAll("SELECT * FROM user_weapons WHERE identifier = @username",{['@username'] = playerID})
	
		delay = 2000
		if(result)then
			for k,v in ipairs(result) do
				-- if (tonumber(user.money) >= tonumber(v.withdraw_cost)) then
					TriggerClientEvent("giveWeapon", player, v.weapon_model, delay)
					-- user:removeMoney((v.withdraw_cost))
				-- else
					-- TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_ROBERTO", 1, "Roberto", false, "Du har ikke råd til dette.")
					-- return
				-- end
			end
			-- TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_ROBERTO", 1, "Roberto", false, "Her er dine våben")
		end
	
	end)
end)

