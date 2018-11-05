--[[Register]]--


--[[Local/Global]]--


--[[Functions]]--


--[[Citizen]]--


--[[Events]]--

AddEventHandler("playerSpawned", function()

--uncomment line if you are using any of my mods.
--décommentez les lignes correspondantes aux mods que vous utilisez

--!!! If you are asking you where to find the mods, see in the wiki, if there is missing one, it's cause i did not release yet, so don't waste time to ask me.
--!!! Si vous vous demandez où sont les autres mods, regardez sur mon wiki, s'il en manque, c'est que je ne les ai pas encore publiés, donc ne perdez pas votre temps à me demander.

--ply_stores
	TriggerServerEvent("ply_basemod:getPlayerBackPackSize")
	TriggerServerEvent("ply_basemod:getAllStuff")

--ply_ressources
	TriggerServerEvent("ply_basemod:getAllRessources")

--ply_menupersonnel
	TriggerServerEvent("ply_basemod:getPlayerInventory")

--ply_garages2 / ply_insurance / ply_prefecture
	TriggerServerEvent("ply_basemod:getGarages")
	TriggerServerEvent("ply_basemod:getPlayerGarage")
	TriggerServerEvent("ply_basemod:getPlayerVehicle")

--ply_entreprises
	TriggerServerEvent("ply_basemod:getJobInfo")
	TriggerServerEvent("ply_basemod:getVitems")
	TriggerServerEvent("ply_basemod:getAllJobRessources")

--ply_poleemploi
	TriggerServerEvent("ply_basemod:getJobs")
end)