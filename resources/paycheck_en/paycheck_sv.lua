RegisterServerEvent('paycheck:welfare')
AddEventHandler('paycheck:welfare', function()

  local paycheckAmount
  TriggerEvent('es:getPlayerFromId', source, function(user)

		if ( user.job == 2  ) then
			 paycheckAmount = 500
       user:addMoney((paycheckAmount))
       TriggerClientEvent('chatMessage', source, "LSPD", {255, 180, 0}, "You received a pay check of $"..paycheckAmount..".")

    elseif ( user.job == 15 ) then
			 paycheckAmount = 500
       user:addMoney((paycheckAmount))
       TriggerClientEvent('chatMessage', source, "LSEMS", {255, 180, 0}, "You received a pay check of $"..paycheckAmount..".")

    elseif ( user.job == 16 ) then
			 paycheckAmount = 500
       user:addMoney((paycheckAmount))
       TriggerClientEvent('chatMessage', source, "MECHANIC", {255, 180, 0}, "You received a pay check of $"..paycheckAmount..".")

    elseif ( user.job == 17 ) then
			 paycheckAmount = 250
       user:addMoney((paycheckAmount))
       TriggerClientEvent('chatMessage', source, "KUMARS", {255, 180, 0}, "You received a pay check of $"..paycheckAmount..".")

     else
			 paycheckAmount = 80 -- welfare amount (no job)
       user:addMoney((paycheckAmount))
       TriggerClientEvent('chatMessage', source, "DWP", {255, 180, 0}, "You received a welfare check of $"..paycheckAmount..".")

		end

 	end)

end)
