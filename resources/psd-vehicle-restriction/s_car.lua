--[[
  Product: FiveM Vehicle Restrictions lua script
  Copyright: (c) 2000 - 2017 by Psd Designs, Inc.
  Programmer: Simon Lewis
  Contact: simon@psd-designs.com
  Version: 0.1

  Unauthorized reproduction or distribution of this program,
  or any portion of it, may result in severe civil and criminal penalties,
  and will be prosecuted to the maximun extent possible under the law.
]]

-- Server Events
RegisterServerEvent("s_IsCarDriveable")
RegisterServerEvent("s_RemoveAllWeapons")

-- Only allow users with rank of one or higher to drive the vehicles
AddEventHandler("s_IsCarDriveable", function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if user then
    if ( user.permission_level >= 1 ) then
       TriggerClientEvent("c_Driveable", source)
      else
       TriggerClientEvent("c_Undriveable", source)
      end
    end
  end)
end)

-- remove civilians weapons when exiting any police vehicles
AddEventHandler("s_RemoveAllWeapons", function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if user then
      if ( user.permission_level == 0 ) then
       TriggerClientEvent("c_RemWeap", source)
      end
    end
  end)
end)
