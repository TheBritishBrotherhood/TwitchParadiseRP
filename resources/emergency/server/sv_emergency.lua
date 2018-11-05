require "resources/mysql-async/lib/MySQL"

function getJobPlayerIs(job_id)  
  return MySQL.Sync.fetchScalar("SELECT job_id FROM users WHERE identifier=@identifier AND job_id=@job_id",
    {['@identifier'] = identifier[1], ['@job_id'] = job_id})
end

function getJobPlayerServiceOn(job_id)  
  return MySQL.Sync.fetchScalar("SELECT enService FROM users WHERE identifier=@identifier AND job_id=@job_id",
    {['@identifier'] = identifier[1], ['@job_id'] = job_id})
end

RegisterServerEvent('es_em:sendEmergency')
AddEventHandler('es_em:sendEmergency',
  function(reason, playerIDInComa, x, y, z)
  TriggerEvent("es:getPlayers", function(players)
    for i,v in pairs(players) do
      TriggerClientEvent('es_em:sendEmergencyToDocs', i, reason, playerIDInComa, x, y, z, source)
    end
  end)
end)

RegisterServerEvent('es_em:getTheCall')
AddEventHandler('es_em:getTheCall',
  function(playerName, playerID, x, y, z, sourcePlayerInComa)
  TriggerEvent("es:getPlayers", function(players)
    for i,v in pairs(players) do
      TriggerClientEvent('es_em:callTaken', i, playerName, playerID, x, y, z, sourcePlayerInComa)
    end
  end)
end)

RegisterServerEvent('es_em:sv_resurectPlayer')
AddEventHandler('es_em:sv_resurectPlayer',
  function(sourcePlayerInComa)
  TriggerClientEvent('es_em:cl_resurectPlayer', sourcePlayerInComa)
end)

RegisterServerEvent('es_em:sv_getJobId')
AddEventHandler('es_em:sv_getJobId',
  function()
    TriggerClientEvent('es_em:cl_setJobId', source, GetJobId(source))
  end)

RegisterServerEvent('es_em:sv_getDocConnected')
AddEventHandler('es_em:sv_getDocConnected',
  function()
  TriggerEvent("es:getPlayers", function(players)
    local identifier
    local table = {}
    local isConnected = false

    for i,v in pairs(players) do
      identifier = GetPlayerIdentifiers(i)
      if (identifier ~= nil) then

        local result = MySQL.Sync.fetchScalar("SELECT job_id FROM users WHERE identifier=@identifier AND job_id=@job_id",
          {['@identifier'] = identifier[1], ['@job_id'] = 6})

        if getJobPlayerIs(11) and getJobPlayerServiceOn(11) == 1 then
          isConnected = true
        end
      end
    end
    TriggerClientEvent('es_em:cl_getDocConnected', source, isConnected)
  end)
end)

RegisterServerEvent('es_em:sv_setService')
AddEventHandler('es_em:sv_setService',
  function(service)
    TriggerEvent('es:getPlayerFromId', source,
      function(user)
        MySQL.Async.execute("UPDATE users SET enService = @service WHERE users.identifier = @identifier", {['@identifier'] = user.identifier, ['@service'] = service})
      end
    )
  end
)

RegisterServerEvent('es_em:sv_sendMessageToPlayerInComa')
AddEventHandler('es_em:sv_sendMessageToPlayerInComa',
  function(sourcePlayerInComa)
    TriggerClientEvent('es_em:cl_sendMessageToPlayerInComa', sourcePlayerInComa)
  end
)

AddEventHandler('playerDropped', function()
  TriggerEvent('es:getPlayerFromId', source,
    function(user)
      MySQL.Async.execute("UPDATE users SET enService = 0 WHERE users.identifier = @identifier", {['@identifier'] = user.identifier})
    end
  )
end)

function GetJobId(source)
  local jobId = -1

  TriggerEvent('es:getPlayerFromId', source,
    function(user)
      local result = MySQL.Sync.fetchAll("SELECT job_id FROM users WHERE users.identifier = @identifier AND job_id IS NOT NULL", {['@identifier'] = user.identifier})

      if (result[1] ~= nil) then
        jobId = result[1].job_id
      end
    end
  )

  return jobId
end