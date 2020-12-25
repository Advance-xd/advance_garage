ESX = nil

Citizen.CreateThread(function()
	while not ESX do
		--Fetching esx library, due to new to esx using this.

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end

end)

local menu = false


function openUI() 
    SetNuiFocus(true, true)
    SendNUIMessage({type = "open", cars = fetchedVehicles})
end

--[[ESX.TriggerServerCallback("garage:fetchPlayerVehicles", function(fetchedVehicles)
    print(fetchedVehicles)
    
end)]]


RegisterNUICallback('close', function(data, cb) 

	closeUI()


end)

function closeUI()
    SetNuiFocus(false, false)
end

RegisterCommand("garagec", function(src)
    closeUI()

end)

RegisterCommand("garageo", function(src)
    openUI()

end)