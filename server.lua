local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('policepa:server:validatePA', function(type,data)

    local src=source
    local Player=QBCore.Functions.GetPlayer(src)

    if not Player then
        return
    end

    local job=Player.PlayerData.job.name

    if not Config.AllowedJobs[job] then
        TriggerClientEvent(
            'QBCore:Notify',
            src,
            'Unauthorized',
            'error'
        )
        return
    end

    TriggerClientEvent(
        'policepa:client:validated',
        src,
        type,
        data
    )

end)



RegisterNetEvent(
'policepa:server:broadcastAudio',
function(url,coords)

 TriggerClientEvent(
   'policepa:client:receiveAudio',
   -1,
   url,
   coords
 )

end)



RegisterNetEvent(
'policepa:server:stopAudio',
function()

 TriggerClientEvent(
   'policepa:client:stopAudio',
   -1
 )

end)