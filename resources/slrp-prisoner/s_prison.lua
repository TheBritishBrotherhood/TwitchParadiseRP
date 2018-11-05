--[[
  Product: FiveM Prisoner lua script
  Copyright: (c) 2000 - 2017 by Psd Designs, Inc.
  Programmer: Simon Lewis
  Contact: simon@psd-designs.com
  Version: 0.1

  Unauthorized reproduction or distribution of this program,
  or any portion of it, may result in severe civil and criminal penalties,
  and will be prosecuted to the maximun extent possible under the law.
]]

-- Server Events
RegisterServerEvent("prison:s_openONE")
RegisterServerEvent("prison:s_openTWO")
RegisterServerEvent("prison:s_openTHREE")
RegisterServerEvent("prison:s_openALL")
RegisterServerEvent("prison:s_Pushback")
RegisterServerEvent("prison:s_openMENU")

-- Only allow users with rank of one or higher to get control menu
AddEventHandler("prison:s_openMENU", function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if ( user.permission_level >= 1 ) then
      TriggerClientEvent("prison:c_OpenMenu", source)
    end
  end)
end)

-- Only allow users with rank of one or higher to open/close gate
AddEventHandler("prison:s_openONE", function()
  TriggerClientEvent("prison:c_OpenCellOne", -1)
end)

-- Only allow users with rank of one or higher to open/close gate
AddEventHandler("prison:s_openTWO", function()
  TriggerClientEvent("prison:c_OpenCellTwo", -1)
end)

-- Only allow users with rank of one or higher to open/close gate
AddEventHandler("prison:s_openTHREE", function()
  TriggerClientEvent("prison:c_OpenCellThree", -1)
end)

-- Only allow users with rank of one or higher to open/close gate
AddEventHandler("prison:s_openALL", function()
  TriggerClientEvent("prison:c_OpenCellAll", -1)
end)

-- Only allow users with rank of one or higher to open/close gate
AddEventHandler("prison:s_Pushback", function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if ( user.permission_level == 0 ) then
      TriggerClientEvent("prison:c_PushUser", source)
    end
  end)
end)
