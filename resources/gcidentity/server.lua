--====================================================================================
-- #Author: Jonathan D & Charlie @ charli62128
-- 
-- Développée pour la communauté n3mtv
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv
--====================================================================================

-- Configuration BDD
require "resources/mysql-async/lib/MySQL"

--====================================================================================
--  Teste si un joueurs a donnée ces infomation identitaire
--====================================================================================
function hasIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    -- local _hasIdentity = function (identifier)
    local result = MySQL.Sync.fetchAll("SELECT nom, prenom FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    local user = result[1]
    return not (user['nom'] == '' or user['prenom'] == '')
    -- end
    -- return pcall(_hasIdentity, identifier)
end

function getIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local result = MySQL.Sync.fetchAll("SELECT users.* , jobs.job_name AS jobs FROM users JOIN jobs WHERE users.job = jobs.job_id and users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if #result == 1 then
        result[1]['id'] = source
        return result[1]
    else
        return {}
    end
end

function setIdentity(identifier, data)
    MySQL.Async.fetchAll("UPDATE users SET nom = @nom, prenom = @prenom, dateNaissance = @dateNaissance, sexe = @sexe, taille = @taille WHERE identifier = @identifier", {
        ['@nom'] = data.nom,
        ['@prenom'] = data.prenom,
        ['@dateNaissance'] = data.dateNaissance,
        ['@sexe'] = data.sexe,
        ['@taille'] = data.taille,
        ['@identifier'] = identifier
    })

end

AddEventHandler('es:playerLoaded', function(source)
    local result = hasIdentity(source)
    if result == false then
        TriggerClientEvent('gc:showRegisterItentity', source, {})
    end
end)

RegisterServerEvent('gc:openIdentity')
AddEventHandler('gc:openIdentity',function(other)
    local data = getIdentity(source)
    if data ~= nil then
        TriggerClientEvent('gc:showItentity', other, {
            nom = data.nom,
            prenom = data.prenom,
            sexe = data.sexe,
            dateNaissance = os.date("%x",os.time(data.dateNaissance)),
            jobs = data.jobs,
            taille = data.taille,
            id = data.id
        })
    end
    ---- ... Date conversion error
    -- TriggerClientEvent('gc:showItentity', source, data)
end)

RegisterServerEvent('gc:openMeIdentity')
AddEventHandler('gc:openMeIdentity',function()
    local data = getIdentity(source)
    if data ~= nil then
        TriggerClientEvent('gc:showItentity', source, {
            nom = data.nom,
            prenom = data.prenom,
            sexe = data.sexe,
            dateNaissance = os.date("%x",os.time(data.dateNaissance)),
            jobs = data.jobs,
            taille = data.taille,
            id = data.id
        })
    end
end)


RegisterServerEvent('gc:setIdentity')
AddEventHandler('gc:setIdentity', function(data)
    setIdentity(GetPlayerIdentifiers(source)[1], data)
end)