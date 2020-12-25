ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Cache = {}

RegisterServerEvent("advance_garage:open")
AddEventHandler("advance_garage:open", function()
    TriggerClientEvent("advance_garage:nui", source, {
        type = "open",
        cache = Cache
    })
end)