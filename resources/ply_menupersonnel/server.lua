--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--

RegisterServerEvent("ply_menupersonnel:setItem")
RegisterServerEvent("ply_menupersonnel:updateQuantity")
RegisterServerEvent("ply_menupersonnel:Reset")
RegisterServerEvent("ply_menupersonnel:useItem")
RegisterServerEvent("ply_menupersonnel:removeItem")

--phone
RegisterServerEvent('ply_menupersonnel:getSteamId')
RegisterServerEvent("ply_menupersonnel:addNewNumero")
RegisterServerEvent("ply_menupersonnel:checkContactServer")
RegisterServerEvent('ply_menupersonnel:deleteContact')
RegisterServerEvent("ply_menupersonnel:sendNewMsg")
RegisterServerEvent("ply_menupersonnel:setMsgReaded")
RegisterServerEvent('ply_menupersonnel:deleteMsg')
RegisterServerEvent('ply_menupersonnel:deleteAllMsg')
RegisterServerEvent('ply_menupersonnel:resetPhone')
RegisterServerEvent('ply_menupersonnel:getPhoneNumber')

--[[Local/Global]]--

--[[Function]]--

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

function getPlayerItemQuantity(item_id)
    return MySQL.Sync.fetchScalar("SELECT quantity FROM user_inventory JOIN items ON `user_inventory`.`item_id` = `items`.`id` WHERE identifier=@identifier AND item_id=@item_id",
        {['@identifier'] = getPlayerID(source), ['@item_id'] = item_id})
end

function removeRessource(item_id)
    MySQL.Sync.execute("UPDATE user_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
        {['@identifier'] = getPlayerID(source), ['@item_id'] = item_id, ['@quantity'] = getPlayerItemQuantity(item_id) - 1})
end

function getPlayerItemType(item_id)
    return MySQL.Sync.fetchScalar("SELECT type FROM user_inventory JOIN items ON `user_inventory`.`item_id` = `items`.`id` WHERE identifier=@identifier AND item_id=@item_id",
        {['@identifier'] = getPlayerID(source), ['@item_id'] = item_id})
end

--phone
function checkIfPhoneNumberAllreadyAssigned(phone_number)
    return MySQL.Sync.fetchScalar("SELECT phone_number FROM users WHERE phone_number=@number", {['@number'] = phone_number})
end

function getPhoneRandomNumber()
    return math.random(10000000,99999999)
end

function getNomFromNumber(number)
    return MySQL.Sync.fetchScalar("SELECT nom FROM users WHERE phone_number=@number", {['@number'] = number})
end

function getIdentifierFromNumber(number)
    return MySQL.Sync.fetchScalar("SELECT identifier FROM users WHERE phone_number=@number", {['@number'] = number})
end

function updateRepertory(player)
    numberslist = {}
    MySQL.Async.fetchAll("SELECT * FROM user_phonelist JOIN users ON `user_phonelist`.`contact_id` = `users`.`identifier` WHERE owner_id=@identifier",
        {['@identifier'] = getPlayerID(source)}, function(data)
        for _, v in pairs(data) do
            t = { ["nom"] = v.nom, ["identifier"] = v.identifier }
            table.insert(numberslist, tonumber(v.identifier), t)
        end
        TriggerClientEvent("ply_menupersonnel:repertoryGetNumberListFromServer", source, numberslist)
    end)
end

function getPlayerPhoneNumer()
    return MySQL.Sync.fetchScalar("SELECT phone_number FROM users WHERE identifier=@identifier", {['@identifier'] = getPlayerID(source)})
end

function setPlayerPhoneNumer(phone_number)
    MySQL.Async.execute("UPDATE users SET phone_number=@number WHERE identifier=@identifier ", {['@number'] = phone_number, ['@identifier'] = getPlayerID(source)}, function(data)
    end)
end

function getContactId(contact)
    return MySQL.Sync.fetchScalar("SELECT contact_id FROM user_phonelist WHERE owner_id=@identifier AND contact_id=@id", {['@identifier'] = getPlayerID(source), ['@id'] = contact})
end

function setNewContact(contact)
    MySQL.Async.execute("INSERT INTO user_phonelist (owner_id, contact_id) VALUES (@owner, @contact)", {['@owner'] = getPlayerID(source), ['@contact'] = contact}, function(data)
    end)
end

function getName(identifier)
    return MySQL.Sync.fetchScalar("SELECT nom FROM users WHERE identifier=@identifier", {['@identifier'] = identifier})
end

function getPhoneNumber(identifier)
    return MySQL.Sync.fetchScalar("SELECT phone_number FROM users WHERE identifier=@identifier", {['@identifier'] = identifier})
end

--[[Events]]--

-- ne sert a rien pour le moment -- sert a ajouter un item, servira pour le dont d'item, il faudra faire le check de la verif si déjà possédé
AddEventHandler("ply_menupersonnel:setItem", function(item, quantity)
    MySQL.Async.execute("INSERT INTO user_inventory (identifier,item_id,quantity) VALUES (@identifier,@item,@qty)",
        {['@identifier'] = getPlayerID(source), ['@item'] = item, ['@qty'] = quantity}, function(data)
    end)
end)

AddEventHandler("ply_menupersonnel:updateQuantity", function(qty, id)
    MySQL.Async.execute("UPDATE user_inventory SET quantity=@qty WHERE identifier=@identifier AND item_id= @id",
        {['@identifier'] = getPlayerID(source), ['@qty'] = tonumber(qty), ['@id'] = tonumber(id)}, function(data)
    end)
end)

AddEventHandler("ply_menupersonnel:Reset", function()
    MySQL.Async.execute("UPDATE user_inventory SET quantity=@qty WHERE identifier=@identifier",
        {['@identifier'] = getPlayerID(source), ['@qty'] = 0}, function(data)
    end)
end)

AddEventHandler("ply_menupersonnel:useItem", function(item_id, stuff)
    if getPlayerItemType(item_id) == 1 then
        TriggerClientEvent("food:drink", source, stuff)
        removeRessource(item_id)
    elseif getPlayerItemType(item_id) == 2 then
        TriggerClientEvent("food:eat", source, stuff)
        removeRessource(item_id)
    elseif getPlayerItemType(item_id) == 3 then
        TriggerClientEvent("ply_menupersonnel:repairKit", source, item_id)
    elseif getPlayerItemType(item_id) == 4 then
        TriggerClientEvent("ply_menupersonnel:lockPick", source, item_id)
    end
end)

AddEventHandler("ply_menupersonnel:removeItem", function(item_id)
    removeRessource(item_id)
end)

--phone
AddEventHandler('ply_menupersonnel:getPhoneNumber',function()
    if (getPlayerPhoneNumer() == "vierge") then
        local phone_number = "06"..tostring(getPhoneRandomNumber())
        if not checkIfPhoneNumberAllreadyAssigned(phone_number) then
            setPlayerPhoneNumer(phone_number)
            TriggerClientEvent('ply_menupersonnel:getPhoneNumberOnLoaded',source, phone_number)
        end
    else
        TriggerClientEvent('ply_menupersonnel:getPhoneNumberOnLoaded', source, getPlayerPhoneNumer())
    end
end)

AddEventHandler('ply_menupersonnel:getSteamId', function()
    TriggerClientEvent('ply_menupersonnel:setSteamId', source, getPlayerID(source))
end)

AddEventHandler("ply_menupersonnel:addNewNumero", function(number)
    local player = getPlayerID(source)
    if not getNomFromNumber(number) then
        TriggerClientEvent("ply_menupersonnel:notifs", source, "~o~Aucun contact trouvé")
    else
        if (getPlayerID(source) == getIdentifierFromNumber(number)) then
            TriggerClientEvent("ply_menupersonnel:notifs", source, " ~r~ Vous ne pouvez pas ajoutez votre numéro ;)" )
            CancelEvent()
        end
        if not getContactId(getIdentifierFromNumber(number)) then
            setNewContact(getIdentifierFromNumber(number))
            TriggerClientEvent("ply_menupersonnel:notifs", source, "~g~Numéro de ~y~".. getNomFromNumber(number) .. " ~g~ajouté" )
            updateRepertory(getIdentifierFromNumber(number))
        else
            TriggerClientEvent("ply_menupersonnel:notifs", source, " ~y~".. getNomFromNumber(number) .. "~r~ existe déjà dans votre répertoire" )
        end
    end
end)

AddEventHandler("ply_menupersonnel:checkContactServer", function(identifier)
    TriggerClientEvent("ply_menupersonnel:notifs", source, "~o~ "..getName(identifier).." : ~s~ "..getPhoneNumber(identifier))
end)

AddEventHandler('ply_menupersonnel:deleteContact', function(contact)
    MySQL.Async.execute("DELETE FROM user_phonelist WHERE owner_id=@owner AND contact_id=@contact", {['@owner'] = getPlayerID(source), ['@contact'] = contact}, function(data)
    end)
    TriggerClientEvent('ply_menupersonnel:notifs', source, "~g~ Contact supprimé !" )
end)

AddEventHandler("ply_menupersonnel:sendNewMsg", function(msg)
    local sender = nil
    msg = {owner_id = getPlayerID(source),receiver = msg.receiver,msg = msg.msg}
    MySQL.Async.execute("INSERT INTO user_message (owner_id,receiver_id,msg,has_read) VALUES (@owner,@receiver,@msg,@read)", {['@owner'] = msg.owner_id, ['@receiver'] = msg.receiver, ['@msg'] = msg.msg, ['@read'] = 0 }, function(data)
    end)
    TriggerClientEvent("ply_menupersonnel:notifs", source, " ~g~ message envoyé" )
    TriggerEvent('es:getPlayerFromId', source, function(sender)
         local SENDER = sender
         TriggerEvent("es:getPlayers", function(users)
             for k , user in pairs(users) do
                 if user.identifier == msg.receiver and k ~= source then
                     TriggerClientEvent("ply_menupersonnel:notifsNewMsg", k, "Nouveau message de ~y~" .. SENDER.nom ..' '..SENDER.prenom)
                 end
             end
         end)
    end)
end)

AddEventHandler("ply_menupersonnel:setMsgReaded", function(msg)
    MySQL.Async.execute("UPDATE user_message SET has_read=1 WHERE receiver_id=@receiver AND msg=@msg AND has_read=@read",
        {['@receiver'] = getPlayerID(source), ['@msg'] = msg.msg, ['@read'] = msg.has_read}, function(data)
    end)
end)

AddEventHandler('ply_menupersonnel:deleteMsg', function(msg)
    MySQL.Async.execute("DELETE FROM user_message WHERE owner_id=@owner AND receiver_id=@receiver AND msg=@msg AND has_read=1 AND receiver_deleted=0 LIMIT 1",{
        ['@owner'] = msg.owner, ['@receiver'] = msg.receiver, ['@msg'] =  msg.msg}, function(data)
    end)
    TriggerClientEvent('ply_menupersonnel:notifs', source, "~g~ Message supprimé !" )
end)

AddEventHandler('ply_menupersonnel:deleteAllMsg', function()
    MySQL.Async.execute("DELETE FROM user_message WHERE receiver_id=@receiver",
        {['@receiver'] = getPlayerID(source)}, function(data)
    end)
    TriggerClientEvent('ply_menupersonnel:notifs', source, "~g~ Messagerie vidée!" )
end)

AddEventHandler('ply_menupersonnel:resetPhone', function()
    MySQL.Async.execute("DELETE FROM user_phonelist WHERE owner_id=@id",
        {['@id'] = getPlayerID(source)}, function(data)
    end)
    MySQL.Async.execute("DELETE FROM user_message WHERE receiver_id=@receiver",
        {['@receiver'] = getPlayerID(source)}, function(data)
    end)
    TriggerClientEvent('ply_menupersonnel:notifs', source, "~g~Téléphone réinitialisé !")
    TriggerClientEvent("ply_basemod:repertoryGetNumberList", source)
    TriggerClientEvent("ply_basemod:messageryGetOldMsg", source)
end)