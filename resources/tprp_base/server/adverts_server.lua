players = {}
host = nil
local adverts = {
	"Join the forum over at www.twitchparadise.com",
    "D'G. Financial - Let us help you fund your dreams.",
	"Dont forget to join the discord linked above.",
    "Don't steal a car, Call Kumar.",
    "Need some cash? Come visit D'G Financial located on Vinewood Boulevard, inside the National Bank."
}
local nextadvert = 1

RegisterServerEvent("Z:newplayer")
AddEventHandler("Z:newplayer", function()
    players[source] = true

    if not host then
        host = source
        TriggerClientEvent("Z:adverthost", source)
    end
end)

AddEventHandler("playerDropped", function(reason)
    players[source] = nil

    if source == host then
        if #players > 0 then
            for mSource, _ in pairs(players) do
                host = mSource
                TriggerClientEvent("Z:adverthost", source)
                break
            end
        else
            host = nil
        end
    end
end)

RegisterServerEvent("Z:timeleftsync")
AddEventHandler("Z:timeleftsync", function(nTimeLeft)
	timeLeft = nTimeLeft
    if timeLeft < 1 then
	   
      TriggerClientEvent("chatMessage", -1, "^7[^4ADVERT^7]", {255, 255, 255}, adverts[nextadvert])
	  nextadvert = nextadvert + 1
	  
	  if nextadvert == 8 then
		nextadvert = 1
	  end
    end
end)
