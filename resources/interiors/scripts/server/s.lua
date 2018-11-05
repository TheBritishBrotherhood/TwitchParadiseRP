
require "resources/mysql-async/lib/MySQL"

RegisterServerEvent("getInteriors")
AddEventHandler('getInteriors', function()
    MySQL.Async.fetchAll("SELECT * FROM interiors WHERE 1 = @where", {['@where'] = "1"}, function(result)
        local ints = {}
        if result ~= nil then
            for i=1,#result do
                local t = table.pack(result[i]['id'],json.decode(result[i]['enter']),json.decode(result[i]['exit']),result[i]['iname'])
                table.insert(ints, t)
            end
        end
    if ints ~= nil then TriggerClientEvent('sendInteriors', source, ints) end
    end)
end)