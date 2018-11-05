--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--

RegisterServerEvent("ply_poleemploi:getJobs")
RegisterServerEvent("ply_poleemploi:updateJobs")



--[[Local/Global]]--




--[[Function]]--

function getPlayerID(source)
	return getIdentifiant(GetPlayerIdentifiers(source))
end

function getIdentifiant(id)
	for _, v in ipairs(id) do
		return v
	end
end

--[[Events]]--

AddEventHandler("ply_poleemploi:updateJobs", function(job_id, job_name)
	MySQL.Async.execute("UPDATE users SET job_id=@job_id WHERE identifier=@identifier", {['@identifier'] = getPlayerID(source), ['@job_id'] = job_id}, function(data)
	end)
	--local job_name = jobName(job_id)
	TriggerClientEvent('ply_poleemploi:JobTrue', source, job_name)
end)