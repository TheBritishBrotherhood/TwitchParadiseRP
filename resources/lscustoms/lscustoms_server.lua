local allowdiscount = false
local givediscount = 150

local tbl = {
   [1] = {locked = false},
   [2] = {locked = false},
   [3] = {locked = false},
   [4] = {locked = false}
}

RegisterServerEvent('lockGarage')
RegisterServerEvent('getGarageInfo')
RegisterServerEvent('takepayment')

AddEventHandler('lockGarage', function(b,garage)
	tbl[tonumber(garage)].locked = b
	TriggerClientEvent('lockGarage',-1,tbl)
	print(json.encode(tbl))
end)

AddEventHandler('getGarageInfo', function()
  TriggerClientEvent('lockGarage',-1,tbl)
  print(json.encode(tbl))
end)

AddEventHandler("takepayment", function(payment)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if ( allowdiscount and user.permission_level >= 1 ) then
         discount = payment - givediscount
         user:removeMoney((discount))
         TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "You have paid $"..payment.. " but you have been given a discount you have paid ( $"..discount.." ).")
        else
		     user:removeMoney((payment))
	       TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "You have paid ".. tonumber(payment).." ~g~")
      end
 	 end)
end)
