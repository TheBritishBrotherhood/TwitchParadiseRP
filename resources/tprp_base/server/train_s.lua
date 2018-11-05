
PlayerCount = 0
list = {}

function ActivateTrain ()
	TriggerClientEvent('StartTrain', GetHostId())
end
--snippet from hardcap to make PlayerCount work

-- yes i know i'm lazy
SetTimeout(5000,ActivateTrain)
AddEventHandler('hardcap:playerActivated', function()
  if not list[source] then
    PlayerCount = PlayerCount + 1
    list[source] = true
		if (PlayerCount) == 1 then -- new session?
			SetTimeout(15000,ActivateTrain)
		end
  end
end)

AddEventHandler('playerDropped', function()
  if list[source] then
    PlayerCount = PlayerCount - 1
    list[source] = nil
  end
end)

