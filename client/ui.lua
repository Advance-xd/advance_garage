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


function openUI(car) 
	SetNuiFocus(true, true)
	SendNUIMessage({type = "open"})
	for key, vehicleData in ipairs(car) do
		local vehicleProps = vehicleData["props"]
		SendNUIMessage({type = "car", cars = GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps["model"])), plate = vehicleData["plate"], spawn = vehicleProps["model"]})
		--[[table.insert(menuElements, {
			["label"] = "Använd " .. GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps["model"])) .. " med plåt - " .. vehicleData["plate"],
			["vehicle"] = vehicleData
		})]]
	end
    
end

--[[ESX.TriggerServerCallback("garage:fetchPlayerVehicles", function(fetchedVehicles)
    print(fetchedVehicles)
    
end)]]


RegisterNUICallback('close', function(data, cb) 

	closeUI()


end)

RegisterNUICallback('spawnveh', function(data, cb) 
	
	print(data.veh)
	SpawnVehicle(data.veh, data.name, data.plate)
	


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

RegisterNetEvent("advance_garage:open")
AddEventHandler("advance_garage:open", function(cars)
	openUI(cars)
end)
