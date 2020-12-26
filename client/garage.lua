ESX = nil

cachedData = {
	["lastChecked"] = GetGameTimer() - 60000,
	["blips"] = {}
}

Citizen.CreateThread(function()
	while not ESX do
		--Fetching esx library, due to new to esx using this.

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(5)

		if not IsControlPressed(0, 21) and IsControlJustPressed(0, 244) then
			OpenVehicleMenu()
		end
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)

RegisterCommand("tempkey", function(src, args)
	local keyUnit = args[1]
	
	if not keyUnit then return end

	GiveTempKey(keyUnit)
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)

	local CanDraw = function(action)
		if action == "vehicle" then
			if IsPedInAnyVehicle(PlayerPedId()) then
				local vehicle = GetVehiclePedIsIn(PlayerPedId())

				if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
					return true
				else
					return false
				end
			else
				return false
			end
		end

		return true
	end

	local GetDisplayText = function(action, garage)
		if not Config.Labels[action] then Config.Labels[action] = action end

		return string.format(Config.Labels[action], action == "vehicle" and GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())))) or garage)
	end

	for garage, garageData in pairs(Config.Garages) do
		local garageBlip = AddBlipForCoord(garageData["positions"]["menu"]["position"])

		SetBlipSprite(garageBlip, 357)
		SetBlipDisplay(garageBlip, 4)
		SetBlipScale (garageBlip, 0.8)
		SetBlipColour(garageBlip, 67)
		SetBlipAsShortRange(garageBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Garage: " .. garage)
		EndTextCommandSetBlipName(garageBlip)
	end

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		CheckVehicle(ped)

		for garage, garageData in pairs(Config.Garages) do
			for action, actionData in pairs(garageData["positions"]) do
				local dstCheck = #(pedCoords - actionData["position"])

				if dstCheck <= 10.0 then
					sleepThread = 5

					local draw = CanDraw(action)

					if draw then
						local markerSize = action == "vehicle" and 5.0 or 1.5

						if dstCheck <= markerSize - 0.1 then
							local usable, displayText = not DoesCamExist(cachedData["cam"]), GetDisplayText(action, garage)

							ESX.ShowHelpNotification(usable and displayText or "Väljer fordon...")

							if usable then
								if IsControlJustPressed(0, 38) then
									cachedData["currentGarage"] = garage

									HandleAction(action)
								end
							end
						end

						DrawScriptMarker({
							["type"] = 6,
							["pos"] = actionData["position"] - vector3(0.0, 0.0, 0.985),
							["sizeX"] = markerSize,
							["sizeY"] = markerSize,
							["sizeZ"] = markerSize,
							["r"] = 0,
							["g"] = 255,
							["b"] = 100
						})
					end
				end
			end
		end

		Citizen.Wait(sleepThread)
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)

	cachedData["lastChecked"] = GetGameTimer() + 10000

	local CanStartVehicle = function(vehicleEntity)
		cachedData["lastChecked"] = GetGameTimer()

		return exports["rp_keysystem"]:HasKey(GetVehicleNumberPlateText(vehicleEntity)) or HasKeyAccess(GetVehicleNumberPlateText(vehicleEntity))
 	end

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped, false) then
			sleepThread = 5

			local vehicleEntity = GetVehiclePedIsUsing(ped)

			if GetPedInVehicleSeat(vehicleEntity, -1) == ped then
				if GetIsVehicleEngineRunning(vehicleEntity) then
					if not cachedData["notified"] then
						ESX.ShowHelpNotification("~INPUT_WEAPON_WHEEL_NEXT~ för att stänga av motorn")

						cachedData["notified"] = true
					end

					if IsControlJustPressed(0, 14) then
						SetVehicleEngineOn(vehicleEntity, false, true, false)

						ESX.ShowNotification("Motor avstängd.", "error", 2000)
					end

					if IsControlPressed(0, 75) and not IsEntityDead(ped) then
						Citizen.Wait(250)

						SetVehicleEngineOn(vehicleEntity, true, true, false)
			
						TaskLeaveVehicle(ped, vehicleEntity, 0)
					end
				else
					SetVehicleEngineOn(vehicleEntity, false, true, false)

					if CanStartVehicle(vehicleEntity) then
						ESX.ShowHelpNotification("~INPUT_WEAPON_WHEEL_PREV~ för att starta motorn.")

						if IsControlJustPressed(0, 15) then
							SetVehicleEngineOn(vehicleEntity, true, true, false)

							ESX.ShowNotification("Motor startad.", "warning", 2000)
						end
					else
						--local hotwirePos = GetOffsetFromEntityInWorldCoords(vehicleEntity, 0.0, 2.0, 1.0)
						--local displayText = cachedData["hotwiring"] and "Tjuvkopplar..." or "[~g~H~s~] Tjuvkoppla"

						ESX.Game.Utils.DrawText3D(hotwirePos, displayText)

						if IsControlJustReleased(0, 74) then
							StartHotwire(vehicleEntity)
						end
					end
				end
			end
		else
			if cachedData["notified"] then
				cachedData["notified"] = false
			end
		end

		Citizen.Wait(sleepThread)
	end
end)

OpenGarageMenu = function()
    local currentGarage = cachedData["currentGarage"]

    if not currentGarage then return end
    

    ESX.TriggerServerCallback("garage:fetchPlayerVehicles", function(fetchedVehicles)
        --HandleCamera(currentGarage, true)
        TriggerEvent('advance_garage:open', fetchedVehicles)

        --[[local menuElements = {}

        for key, vehicleData in ipairs(fetchedVehicles) do
            local vehicleProps = vehicleData["props"]

            table.insert(menuElements, {
                ["label"] = "Använd " .. GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps["model"])) .. " med plåt - " .. vehicleData["plate"],
                ["vehicle"] = vehicleData
            })
        end

        if #menuElements == 0 then
            table.insert(menuElements, {
                ["label"] = "Du har inte några parkerade fordon här."
            })
        elseif #menuElements > 0 then
            SpawnLocalVehicle(menuElements[1]["vehicle"]["props"], currentGarage)
        end

        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_garage_menu", {
            ["title"] = "Garage - " .. currentGarage,
            ["align"] = Config.AlignMenu,
            ["elements"] = menuElements
        }, function(menuData, menuHandle)
            local currentVehicle = menuData["current"]["vehicle"]

            if currentVehicle then
                menuHandle.close()

                SpawnVehicle(currentVehicle["props"])
            end
        end, function(menuData, menuHandle)
            HandleCamera(currentGarage, false)

            menuHandle.close()
        end, function(menuData, menuHandle)
            local currentVehicle = menuData["current"]["vehicle"]

            if currentVehicle then
                SpawnLocalVehicle(currentVehicle["props"])
            end
        end)]]
    end, currentGarage)
end

OpenVehicleMenu = function()
    local menuElements = {}

    local gameVehicles = ESX.Game.GetVehicles()
    local pedCoords = GetEntityCoords(PlayerPedId())

    for _, vehicle in ipairs(gameVehicles) do
        if DoesEntityExist(vehicle) then
            local vehiclePlate = Config.Trim(GetVehicleNumberPlateText(vehicle))

            if #vehiclePlate == 6 or HasKeyAccess(vehiclePlate) then
                if exports["rp_keysystem"]:HasKey(vehiclePlate) or HasKeyAccess(vehiclePlate) then
                    local dstCheck = math.floor(#(pedCoords - GetEntityCoords(vehicle)))

                    table.insert(menuElements, {
                        ["label"] = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. " med plåt - " .. vehiclePlate .. " - " .. dstCheck .. " meter ifrån dig.",
                        ["vehicleData"] = vehicleData,
                        ["vehicleEntity"] = vehicle
                    })
                end
            end
        end
    end

    if #menuElements == 0 then
        table.insert(menuElements, {
            ["label"] = "Du har inga fordon ute i staden."
        })
    end

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_vehicle_menu", {
        ["title"] = "Nuvarande fordon.",
        ["align"] = Config.AlignMenu,
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        local currentVehicle = menuData["current"]["vehicleEntity"]

        if currentVehicle then
            ChooseVehicleAction(currentVehicle, function(actionChosen)
                VehicleAction(currentVehicle, actionChosen)
            end)
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end, function(menuData, menuHandle)
        local currentVehicle = menuData["current"]["vehicle"]

        if currentVehicle then
            SpawnLocalVehicle(currentVehicle["props"])
        end
    end)
end

ChooseVehicleAction = function(vehicleEntity, callback)
    if not cachedData["blips"] then cachedData["blips"] = {} end

    local menuElements = {
        {
            ["label"] = (GetVehicleDoorLockStatus(vehicleEntity) == 1 and "Lås" or "Lås upp") .. " fordon.",
            ["action"] = "change_lock_state"
        },
        {
            ["label"] = (GetIsVehicleEngineRunning(vehicleEntity) and "Stäng av" or "Sätt på") .. " motorn.",
            ["action"] = "change_engine_state"
        },
        {
            ["label"] = (DoesBlipExist(cachedData["blips"][vehicleEntity]) and "Stäng av" or "Sätt på") .. " gps trackern.",
            ["action"] = "change_gps_state"
        },
        {
            ["label"] = "Hantera fordonsdörrar.",
            ["action"] = "change_door_state"
        },
        {
            ["label"] = "Välj säte.",
            ["action"] = "choose_vehicle_seat"
        },
    }

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "second_vehicle_menu", {
        ["title"] = "Välj en handling för fordon - " .. GetVehicleNumberPlateText(vehicleEntity),
        ["align"] = Config.AlignMenu,
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        local currentAction = menuData["current"]["action"]

        if currentAction then
            menuHandle.close()

            callback(currentAction)
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

VehicleAction = function(vehicleEntity, action)
    local dstCheck = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicleEntity))

    while not NetworkHasControlOfEntity(vehicleEntity) do
        Citizen.Wait(0)
    
        NetworkRequestControlOfEntity(vehicleEntity)
    end

    if action == "change_lock_state" then
        if dstCheck >= Config.RangeCheck then return ESX.ShowNotification("Du är för långt ifrån fordonet för att kontrollera det.") end

        PlayAnimation(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click", {
            ["speed"] = 8.0,
            ["speedMultiplier"] = 8.0,
            ["duration"] = 1820,
            ["flag"] = 49,
            ["playbackRate"] = false
        })

        StartVehicleHorn(vehicleEntity, 50, 1, false)

        for index = 1, 4 do
            if (index % 2 == 0) then
                SetVehicleLights(vehicleEntity, 0)
            else
                SetVehicleLights(vehicleEntity, 2)
            end

            Citizen.Wait(300)
        end
        
        local vehicleLockState = GetVehicleDoorLockStatus(vehicleEntity)

        if vehicleLockState == 1 then
            SetVehicleDoorsLocked(vehicleEntity, 2)
            PlayVehicleDoorCloseSound(vehicleEntity, 1)
        elseif vehicleLockState == 2 then
            SetVehicleDoorsLocked(vehicleEntity, 1)
            PlayVehicleDoorOpenSound(vehicleEntity, 0)

            local oldCoords = GetEntityCoords(PlayerPedId())
            local oldHeading = GetEntityHeading(PlayerPedId())

            if not IsPedInVehicle(PlayerPedId(), vehicleEntity) and not DoesEntityExist(GetPedInVehicleSeat(vehicleEntity, -1)) then
                SetPedIntoVehicle(PlayerPedId(), vehicleEntity, -1)
                TaskLeaveVehicle(PlayerPedId(), vehicleEntity, 16)
                SetEntityCoords(PlayerPedId(), oldCoords - vector3(0.0, 0.0, 0.99))
                SetEntityHeading(PlayerPedId(), oldHeading)
            end
        end

        ESX.ShowNotification(GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicleEntity))) .. " med plåt - " .. GetVehicleNumberPlateText(vehicleEntity) .. " är nu " .. (vehicleLockState == 1 and "LÅST" or "UPPLÅST"))
    elseif action == "change_door_state" then
        if dstCheck >= Config.RangeCheck then return ESX.ShowNotification("Du är för långt ifrån fordonet för att kontrollera det.") end

        ChooseDoor(vehicleEntity, function(doorChosen)
            if doorChosen then
                if GetVehicleDoorAngleRatio(vehicleEntity, doorChosen) == 0 then
                    SetVehicleDoorOpen(vehicleEntity, doorChosen, false, false)
                else
                    SetVehicleDoorShut(vehicleEntity, doorChosen, false, false)
                end
            end
        end)
    elseif action == "change_engine_state" then
        if dstCheck >= Config.RangeCheck then return ESX.ShowNotification("Du är för långt ifrån fordonet för att kontrollera det.") end

        if GetIsVehicleEngineRunning(vehicleEntity) then
            SetVehicleEngineOn(vehicleEntity, false, false)

            cachedData["engineState"] = true

            Citizen.CreateThread(function()
                while cachedData["engineState"] do
                    Citizen.Wait(5)

                    SetVehicleUndriveable(vehicleEntity, true)
                end

                SetVehicleUndriveable(vehicleEntity, false)
            end)
        else
            cachedData["engineState"] = false

            SetVehicleEngineOn(vehicleEntity, true, true)
        end
    elseif action == "change_gps_state" then
        if DoesBlipExist(cachedData["blips"][vehicleEntity]) then
            RemoveBlip(cachedData["blips"][vehicleEntity])
        else
            cachedData["blips"][vehicleEntity] = AddBlipForEntity(vehicleEntity)
    
            SetBlipSprite(cachedData["blips"][vehicleEntity], GetVehicleClass(vehicleEntity) == 8 and 226 or 225)
            SetBlipScale(cachedData["blips"][vehicleEntity], 1.05)
            SetBlipColour(cachedData["blips"][vehicleEntity], 30)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(GetVehicleClass(vehicleEntity) == 18 and "Jobb fordon - " .. GetVehicleNumberPlateText(vehicleEntity) or "Personligt fordon - " .. GetVehicleNumberPlateText(vehicleEntity))
            EndTextCommandSetBlipName(cachedData["blips"][vehicleEntity])
        end
    elseif action == "choose_vehicle_seat" then
        if dstCheck >= Config.RangeCheck then return ESX.ShowNotification("Du är för långt ifrån fordonet för att kontrollera det.") end

        ChooseVehicleSeat(vehicleEntity, function(choosenSeat)
            if choosenSeat then
                if IsVehicleSeatFree(vehicleEntity, choosenSeat) then
                    TaskEnterVehicle(PlayerPedId(), vehicleEntity, 0, choosenSeat, 1, normal)
                else
                    ESX.ShowNotification("Det sätet är inte tillgängligt.", "error")
                end
            end
        end)
    end
end

ChooseVehicleSeat = function(vehicleEntity, callback)
    local menuElements = {
        {
            ["label"] = "Förarsäte.",
            ["seat"] = -1
        },
        {
            ["label"] = "Passagerarsäte.",
            ["seat"] = 0
        },
        {
            ["label"] = "Säte 3.",
            ["seat"] = 1
        },
        {
            ["label"] = "Säte 4.",
            ["seat"] = 2
        },
        {
            ["label"] = "Säte 5.",
            ["seat"] = 3
        },
        {
            ["label"] = "Säte 6.",
            ["seat"] = 4
        }
    }

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "seat_vehicle_menu", {
        ["title"] = "Välj ett säte",
        ["align"] = Config.AlignMenu,
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        local currentSeat = menuData["current"]["seat"]

        if currentSeat then
            callback(currentSeat)
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

ChooseDoor = function(vehicleEntity, callback)
    local menuElements = {
        {
            ["label"] = "Vänster framdörr.",
            ["door"] = 0
        },
        {
            ["label"] = "Höger framdörr.",
            ["door"] = 1
        },
        {
            ["label"] = "Vänster bakdörr.",
            ["door"] = 2
        },
        {
            ["label"] = "Höger bakdörr.",
            ["door"] = 3
        },
        {
            ["label"] = "Huven.",
            ["door"] = 4
        },
        {
            ["label"] = "Bakluckan.",
            ["door"] = 5
        }
    }

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "door_vehicle_menu", {
        ["title"] = "Välj en dörr",
        ["align"] = Config.AlignMenu,
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        local currentDoor = menuData["current"]["door"]

        if currentDoor then
            callback(currentDoor)
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

GiveTempKey = function(keyUnit)
    if not cachedData["tempKeys"] then
        cachedData["tempKeys"] = {}
    end

    cachedData["tempKeys"][Config.Trim(keyUnit)] = true
end

HasKeyAccess = function(plateCheck)
    local plateArray = {
        ["SEPOLIS"] = "police",
        ["CARD"] = "cardealer",
        ["AMBUL"] = "ambulance",
        ["BENNY"] = "bennys",
        ["AUTO"] = "mecano",
        ["NEWS"] = "news",
        ["POST"] = "postman"
    }

    if cachedData["tempKeys"] and cachedData["tempKeys"][Config.Trim(plateCheck)] then
        return true
    end

	for plate, job in pairs(plateArray) do
		if plateCheck == plate then
			if job == ESX.PlayerData["job"]["name"] then
				return true
			end

			break
		end
	end

	return false
end

StartHotwire = function(vehicleEntity)
    if cachedData["hotwiring"] then return end

    cachedData["hotwiring"] = true

    Citizen.CreateThread(function()
        local ped = PlayerPedId()

        if not HasAnimDictLoaded("mini@repair") then
            ESX.LoadAnimDict("mini@repair")
        end

        local startedHotwiring = GetGameTimer()

        TaskPlayAnim(ped, "mini@repair", "fixing_a_player", 8.0, -8, -1, 17, 0, 0, 0, 0)

        while cachedData["hotwiring"] do
            Citizen.Wait(5)

            if not IsEntityPlayingAnim(ped, "mini@repair", "fixing_a_player", 3) then
                break
            end

            if GetGameTimer() - startedHotwiring > 25000 then
                local randomLuck = math.random(5)

                if randomLuck > 3 then
                    SetVehicleEngineOn(vehicleEntity, true, true, false)

                    ESX.ShowNotification("Hotwire klarad...", "warning", 2500)
                else
                    ESX.ShowNotification("Hotwire ej klarad...", "error", 2500)
                end

                break
            end
        end

        ClearPedTasks(ped)

        cachedData["hotwiring"] = false
    end)
end

SpawnLocalVehicle = function(vehicleProps)
	local spawnpoint = Config.Garages[cachedData["currentGarage"]]["positions"]["vehicle"]

	WaitForModel(vehicleProps)

	if DoesEntityExist(cachedData["vehicle"]) then
		DeleteEntity(cachedData["vehicle"])
	end
	
	if not ESX.Game.IsSpawnPointClear(spawnpoint["position"], 3.0) then 
		return ESX.ShowNotification("Något fordon står ivägen.")
	end
	
	if not IsModelValid(vehicleProps) then
		return
	end

	ESX.Game.SpawnLocalVehicle(vehicleProps["model"], spawnpoint["position"], spawnpoint["heading"], function(yourVehicle)
		cachedData["vehicle"] = yourVehicle

		SetVehicleProperties(yourVehicle, vehicleProps)

		SetModelAsNoLongerNeeded(vehicleProps["model"])
	end)
end

SpawnVehicle = function(vehicleProps, car, plate)

    local spawnpoint = Config.Garages[cachedData["currentGarage"]]["positions"]["vehicle"]
	--WaitForModel(vehicleProps)

	if DoesEntityExist(cachedData["vehicle"]) then
		DeleteEntity(cachedData["vehicle"])
	end
	
	if not ESX.Game.IsSpawnPointClear(spawnpoint["position"], 3.0) then 
        return ESX.ShowNotification("Något fordon står ivägen.")
	end
	
	local gameVehicles = ESX.Game.GetVehicles()

	for i = 1, #gameVehicles do
		local vehicle = gameVehicles[i]

        if DoesEntityExist(vehicle) then
			if Config.Trim(GetVehicleNumberPlateText(vehicle)) == Config.Trim(plate) then
				ESX.ShowNotification("Du har redan ute detta fordon, vänligen parkera fordonet innan du tar ut det igen.")

				return HandleCamera(cachedData["currentGarage"])
			end
		end
	end

	ESX.Game.SpawnVehicle(car, spawnpoint["position"], spawnpoint["heading"], function(yourVehicle)
		SetVehicleProperties(yourVehicle, car)
        
        SetVehicleNumberPlateText(yourVehicle, plate)

        NetworkFadeInEntity(yourVehicle, true, true)

		SetModelAsNoLongerNeeded(car)

		TaskWarpPedIntoVehicle(PlayerPedId(), yourVehicle, -1)

        SetEntityAsMissionEntity(yourVehicle, true, true)
        
        ESX.ShowNotification("Du kör nu fordonet.")

        HandleCamera(cachedData["currentGarage"])
	end)
end

PutInVehicle = function()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())

	if DoesEntityExist(vehicle) then
		local vehicleProps = GetVehicleProperties(vehicle)

		ESX.TriggerServerCallback("garage:validateVehicle", function(valid)
            if valid then
                if not AloneInVehicle(vehicle) then return ESX.ShowNotification("Vänligen säg åt dina passagerare att gå ur fordonet.") end

				TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
	
				while IsPedInVehicle(PlayerPedId(), vehicle, true) do
					Citizen.Wait(0)
				end
	
				Citizen.Wait(500)
	
				NetworkFadeOutEntity(vehicle, true, true)
	
				Citizen.Wait(100)
	
				ESX.Game.DeleteVehicle(vehicle)

				ESX.ShowNotification("Du parkerade fordonet.")
			else
				ESX.ShowNotification("Kan du verkligen parkera detta fordon här?")
			end

		end, vehicleProps, cachedData["currentGarage"])
	end
end

AloneInVehicle = function(vehicle)
    local occupiedSeats = 0

    local vehicleSeats = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))

    for vehicleSeat = 1, vehicleSeats do
        if DoesEntityExist(GetPedInVehicleSeat(vehicle, vehicleSeat - 2)) then
            occupiedSeats = occupiedSeats + 1
        end
    end

    return occupiedSeats < 2
end

CheckVehicle = function(ped)
    local vehicleEntity = GetVehiclePedIsUsing(ped)

    if not DoesEntityExist(vehicleEntity) then return end
    if not GetPedInVehicleSeat(vehicleEntity, -1) == ped then return end

    if GetGameTimer() - cachedData["lastChecked"] < 1000 then return end

    cachedData["lastChecked"] = GetGameTimer()

    local vehiclePosition = GetEntityCoords(vehicleEntity)

    if cachedData["lastPos"] then
        local distanceTraveled = #(vehiclePosition - cachedData["lastPos"])
        
        local oldDistanceTraveled = DecorGetFloat(vehicleEntity, "distanceTraveled")

        DecorSetFloat(vehicleEntity, "distanceTraveled", (oldDistanceTraveled + distanceTraveled) + 0.0)
    end

    cachedData["lastPos"] = vehiclePosition
end

SetVehicleProperties = function(vehicle, vehicleProps)
    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

    SetVehicleEngineHealth(vehicle, vehicleProps["engineHealth"] and vehicleProps["engineHealth"] + 0.0 or 1000.0)
    SetVehicleBodyHealth(vehicle, vehicleProps["bodyHealth"] and vehicleProps["bodyHealth"] + 0.0 or 1000.0)
    SetVehicleFuelLevel(vehicle, vehicleProps["fuelLevel"] and vehicleProps["fuelLevel"] + 0.0 or 1000.0)

    DecorSetFloat(vehicle, "distanceTraveled", vehicleProps["distanceTraveled"] or 0.0)

    if vehicleProps["windows"] then
        for windowId = 1, 13, 1 do
            if vehicleProps["windows"][windowId] == false then
                SmashVehicleWindow(vehicle, windowId)
            end
        end
    end

    if vehicleProps["tyres"] then
        for tyreId = 1, 7, 1 do
            if vehicleProps["tyres"][tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end

    if vehicleProps["doors"] then
        for doorId = 0, 5, 1 do
            if vehicleProps["doors"][doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
    end
end

GetVehicleProperties = function(vehicle)
    if DoesEntityExist(vehicle) then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

        vehicleProps["tyres"] = {}
        vehicleProps["windows"] = {}
        vehicleProps["doors"] = {}

        for id = 1, 7 do
            local tyreId = IsVehicleTyreBurst(vehicle, id, false)
        
            if tyreId then
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = tyreId
        
                if tyreId == false then
                    tyreId = IsVehicleTyreBurst(vehicle, id, true)
                    vehicleProps["tyres"][ #vehicleProps["tyres"]] = tyreId
                end
            else
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = false
            end
        end

        for id = 1, 13 do
            local windowId = IsVehicleWindowIntact(vehicle, id)

            if windowId ~= nil then
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = windowId
            else
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = true
            end
        end
        
        for id = 0, 5 do
            local doorId = IsVehicleDoorDamaged(vehicle, id)
        
            if doorId then
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = doorId
            else
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = false
            end
        end

        vehicleProps["engineHealth"] = GetVehicleEngineHealth(vehicle)
        vehicleProps["bodyHealth"] = GetVehicleBodyHealth(vehicle)
        vehicleProps["fuelLevel"] = GetVehicleFuelLevel(vehicle)
        vehicleProps["distanceTraveled"] = DecorGetFloat(vehicle, "distanceTraveled")

        return vehicleProps
    end
end

HandleAction = function(action)
    if action == "menu" then
        OpenGarageMenu()
    elseif action == "vehicle" then
        PutInVehicle()
    end
end

HandleCamera = function(garage, toggle)
    local Camerapos = Config.Garages[garage]["camera"]

    if not Camerapos then return end

	if not toggle then
		if cachedData["cam"] then
			DestroyCam(cachedData["cam"])
		end
		
		if DoesEntityExist(cachedData["vehicle"]) then
			DeleteEntity(cachedData["vehicle"])
		end

		RenderScriptCams(0, 1, 750, 1, 0)

		return
	end

	if cachedData["cam"] then
		DestroyCam(cachedData["cam"])
	end

	cachedData["cam"] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

	SetCamCoord(cachedData["cam"], Camerapos["x"], Camerapos["y"], Camerapos["z"])
	SetCamRot(cachedData["cam"], Camerapos["rotationX"], Camerapos["rotationY"], Camerapos["rotationZ"])
	SetCamActive(cachedData["cam"], true)

	RenderScriptCams(1, 1, 750, 1, 1)

	Citizen.Wait(500)
end

DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["sizeX"] or 1.0, markerData["sizeY"] or 1.0, markerData["sizeZ"] or 1.0, markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, 100, false, true, 2, false, false, false, false)
end

PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
      
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

WaitForModel = function(model)
    local DrawScreenText = function(text, red, green, blue, alpha)
        SetTextFont(4)
        SetTextScale(0.0, 0.5)
        SetTextColour(red, green, blue, alpha)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(true)
    
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(0.5, 0.5)
    end

    if not IsModelValid(model) then
        ESX.ShowNotification("Denna modellen existerar ej.")

        return false
    end

	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	
	while not HasModelLoaded(model) do
		Citizen.Wait(0)

		DrawScreenText("Laddar model " .. GetLabelText(GetDisplayNameFromVehicleModel(model)) .. "...", 255, 255, 255, 150)
    end
    
    return true
end

local decors = {
    {
        ["decorName"] = "distanceTraveled",
        ["decorType"] = 1
    }
}

for decorIndex, decorData in ipairs(decors) do
    DecorRegister(decorData["decorName"], decorData["decorType"])
end