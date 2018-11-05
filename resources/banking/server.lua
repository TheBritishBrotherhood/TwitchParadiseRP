require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "tprp")

-- HELPER FUNCTIONS
function bankBalance(player)
  local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@name'", {['@name'] = player})
  local result = MySQL:getResults(executed_query, {'bankbalance'}, "identifier")
  return tonumber(result[1].bankbalance)
end

function deposit(player, amount)
  local bankbalance = bankBalance(player)
  local new_balance = bankbalance + amount
  MySQL:executeQuery("UPDATE users SET `bankbalance`='@value' WHERE identifier = '@identifier'", {['@value'] = new_balance, ['@identifier'] = player})
end

function withdraw(player, amount)
  local bankbalance = bankBalance(player)
  local new_balance = bankbalance - amount
  MySQL:executeQuery("UPDATE users SET `bankbalance`='@value' WHERE identifier = '@identifier'", {['@value'] = new_balance, ['@identifier'] = player})
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.abs(math.floor(num * mult + 0.5) / mult)
end

-- Check Bank Balance
TriggerEvent('es:addCommand', 'checkbalance', function(source, args, user)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local bankbalance = bankBalance(player)
    TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Your current account balance: ~g~$".. bankbalance)
    TriggerClientEvent("banking:updateBalance", source, bankbalance)
    CancelEvent()
  end)
end)

-- Bank Deposit
TriggerEvent('es:addCommand', 'deposit', function(source, args, user)
  local amount = ""
  local player = user.identifier
  for i=1,#args do
    amount = args[i]
  end
  TriggerClientEvent('bank:deposit', source, amount)
end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Input too high^0")
        CancelEvent()
      else
      	if(tonumber(rounded) <= tonumber(user:money)) then
          user:removeMoney((rounded))
          local player = user.identifier
          deposit(player, rounded)
          local new_balance = bankBalance(player)
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Deposited: ~g~$".. rounded .." ~n~~s~New Balance: ~g~$" .. new_balance)
          TriggerClientEvent("banking:updateBalance", source, new_balance)
          TriggerClientEvent("banking:addBalance", source, rounded)
          CancelEvent()
        else
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Not enough cash!^0")
          CancelEvent()
        end
      end
  end)
end)

-- Bank Withdraw
TriggerEvent('es:addCommand', 'withdraw', function(source, args, user)
  local amount = ""
  local player = user.identifier
  for i=1,#args do
    amount = args[i]
  end
  TriggerClientEvent('bank:withdraw', source, amount)
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Input too high^0")
        CancelEvent()
      else
        local player = user.identifier
        local bankbalance = bankBalance(player)
        if(tonumber(rounded) <= tonumber(bankbalance)) then
          withdraw(player, rounded)
          user:addMoney((rounded))
          local new_balance = bankBalance(player)
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Withdrew: ~g~$".. rounded .." ~n~~s~New Balance: ~g~$" .. new_balance)
          TriggerClientEvent("banking:updateBalance", source, new_balance)
          TriggerClientEvent("banking:removeBalance", source, rounded)
          CancelEvent()
        else
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Not enough money in account!^0")
          CancelEvent()
        end
      end
  end)
end)

-- Bank Transfer
TriggerEvent('es:addCommand', 'transfer', function(source, args, user)
  local fromPlayer
  local toPlayer
  local amount
  if (args[2] ~= nil and tonumber(args[3]) > 0) then
    fromPlayer = tonumber(source)
    toPlayer = tonumber(args[2])
    amount = tonumber(args[3])
    TriggerClientEvent('bank:transfer', source, fromPlayer, toPlayer, amount)
	else
    TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Use format /transfer [id] [amount]^0")
    return false
  end
end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(fromPlayer, toPlayer, amount)
  if tonumber(fromPlayer) == tonumber(toPlayer) then
    TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Cannot transfer to self^0")
    CancelEvent()
  else
    TriggerEvent('es:getPlayerFromId', fromPlayer, function(user)
        local rounded = round(tonumber(amount), 0)
        if(string.len(rounded) >= 9) then
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Input too high^0")
          CancelEvent()
        else
          local player = user.identifier
          local bankbalance = bankBalance(player)
          if(tonumber(rounded) <= tonumber(bankbalance)) then
            withdraw(player, rounded)
            local new_balance = bankBalance(player)
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Transferred: ~r~-$".. rounded .." ~n~~s~New Balance: ~g~$" .. new_balance)
            TriggerClientEvent("banking:updateBalance", source, new_balance)
            TriggerClientEvent("banking:removeBalance", source, rounded)
            TriggerEvent('es:getPlayerFromId', toPlayer, function(user2)
                local recipient = user2.identifier
                deposit(recipient, rounded)
                new_balance2 = bankBalance(recipient)
                TriggerClientEvent("es_freeroam:notify", toPlayer, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Received: ~g~$".. rounded .." ~n~~s~New Balance: ~g~$" .. new_balance2)
                TriggerClientEvent("banking:updateBalance", toPlayer, new_balance2)
                TriggerClientEvent("banking:addBalance", toPlayer, rounded)
                CancelEvent()
            end)
            CancelEvent()
          else
            TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Not enough money in account!^0")
            CancelEvent()
          end
        end
    end)
  end
end)

-- Give Cash
TriggerEvent('es:addCommand', 'givecash', function(source, args, user)
  local fromPlayer
  local toPlayer
  local amount
  if (args[2] ~= nil and tonumber(args[3]) > 0) then
    fromPlayer = tonumber(source)
    toPlayer = tonumber(args[2])
    amount = tonumber(args[3])
    TriggerClientEvent('bank:givecash', source, toPlayer, amount)
	else
    TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Use format /givecash [id] [amount]^0")
    return false
  end
end)

RegisterServerEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if (tonumber(user.money) >= tonumber(amount)) then
			local player = user.identifier
			user:removeMoney(amount)
			TriggerEvent('es:getPlayerFromId', toPlayer, function(recipient)
				recipient:addMoney(amount)
				TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Gave cash: ~r~-$".. amount .." ~n~~s~Wallet: ~g~$" .. user.money)
				TriggerClientEvent("es_freeroam:notify", toPlayer, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Received cash: ~g~$".. amount .." ~n~~s~Wallet: ~g~$" .. recipient.money)
			end)
		else
			if (tonumber(user.money) < tonumber(amount)) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Not enough money in wallet!^0")
        CancelEvent()
			end
		end
	end)
end)

AddEventHandler('es:playerLoaded', function(source)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local player = user.identifier
      local bankbalance = bankBalance(player)
      TriggerClientEvent("banking:updateBalance", source, bankbalance)
    end)
end)
