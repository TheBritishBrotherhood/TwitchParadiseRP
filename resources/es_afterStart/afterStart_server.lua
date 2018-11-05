require "resources/mysql-async/lib/MySQL"

AddEventHandler('onResourceStart', function(resource)
  MySQL.Async.execute("UPDATE user_vehicle SET `vehicle_state`=@value WHERE `vehicle_state`='Out'",
  {['@value'] = "In"})
end)