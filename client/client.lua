local QBCore = exports['qb-core']:GetCoreObject()
local menuOpen = false

RegisterNetEvent('elevator:client:openmenu', function(updown, updown2)
    Wait(500)
    if not menuOpen then
        menuOpen = true
        exports['qb-menu']:openMenu({
            {
                header = "Elevator Actions",
                isMenuHeader = true,
            },
            {
                header = "Use Elevator",
                txt = "Go "..updown.." in elevator",
                params = {
                    event = "elevator:client:useElevator",
                    args = {
                        which = updown2
                    }
                }
            },
        })
    end
end)

CreateThread(function()
    while true do
        sleep = 1000
        if LocalPlayer.state['isLoggedIn'] then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local currentTeleport = 1
            if Config.Draw3D then
                for k, v in pairs(Config.Teleports["lower"]) do
                    local dist = #(pos - vector3(v.x, v.y, v.z))
                    if dist < 1.5 then
                        sleep = 7
                        DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Take the elevator to the roof")
                        if IsControlJustReleased(0, 38) then
                            DoScreenFadeOut(500)
                            while not IsScreenFadedOut() do
                                Wait(10)
                            end

                            currentTeleport = k

                            local coords = Config.Teleports["upper"][currentTeleport]
                            SetEntityCoords(ped, coords.x, coords.y, coords.z, 0, 0, 0, false)
                            SetEntityHeading(ped, coords.w)

                            Wait(100)

                            DoScreenFadeIn(1000)
                        end
                    end
                end

                for k, v in pairs(Config.Teleports["upper"]) do
                    local dist = #(pos - vector3(v.x, v.y, v.z))
                    if dist < 1.5 then
                        sleep = 7
                        DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Take the elevator down")
                        if IsControlJustReleased(0, 38) then
                            DoScreenFadeOut(500)
                            while not IsScreenFadedOut() do
                                Wait(10)
                            end

                            currentTeleport = k

                            local coords = Config.Teleports["lower"][currentTeleport]
                            SetEntityCoords(ped, coords.x, coords.y, coords.z, 0, 0, 0, false)
                            SetEntityHeading(ped, coords.w)

                            Wait(100)

                            DoScreenFadeIn(1000)
                        end
                    end
                end
            else
                for k, v in pairs(Config.Teleports["lower"]) do
                    local dist = #(pos - vector3(v.x, v.y, v.z))
                    if dist < 1.5 then
                        sleep = 7
                        if not menuOpen then
                        TriggerEvent('elevator:client:openmenu', "up", "upper")
                        Wait(10000)
                        menuOpen = false
                        end
                    end
                end

                for k, v in pairs(Config.Teleports["upper"]) do
                    local dist = #(pos - vector3(v.x, v.y, v.z))
                    if dist < 1.5 then
                        sleep = 7
                        if not menuOpen then
                        TriggerEvent('elevator:client:openmenu', "down", "lower")
                        Wait(10000)
                        menuOpen = false
                        end
                    end
                    RegisterNetEvent('elevator:client:useElevator', function(data)
                        if data.which == "upper" then
                            QBCore.Functions.Progressbar('waiting', 'Waiting for Elevator...', 5000, true, true, { -- Name | Label | Time | useWhileDead | canCancel
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = 'mp_sleep',
                            anim = 'sleep_loop',
                            flags = 16,
                        }, {}, {}, function() -- Play When Done
                            DoScreenFadeOut(1000)
                            while not IsScreenFadedOut() do
                                Wait(10)
                            end
                    
                            currentTeleport = k
                    
                            local coords = Config.Teleports["upper"][currentTeleport]
                            SetEntityCoords(ped, coords.x, coords.y, coords.z, 0, 0, 0, false)
                            SetEntityHeading(ped, coords.w)
                    
                            Wait(1000)
                    
                            DoScreenFadeIn(1500)
                        end, function() -- Play When Cancel
                            QBCore.Functions.Notify("Canceled", "error", "1500")
                        end)
                        elseif data.which == "lower" then
                            QBCore.Functions.Progressbar('waiting', 'Waiting for Elevator', 5000, true, true, { -- Name | Label | Time | useWhileDead | canCancel
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = 'mp_sleep',
                            anim = 'sleep_loop',
                            flags = 16,
                        }, {}, {}, function() -- Play When Done
                            DoScreenFadeOut(1000)
                            while not IsScreenFadedOut() do
                            Wait(10)
                            end
            
                            currentTeleport = k
            
                            local coords = Config.Teleports["lower"][currentTeleport]
                            SetEntityCoords(ped, coords.x, coords.y, coords.z, 0, 0, 0, false)
                            SetEntityHeading(ped, coords.w)
            
                            Wait(1000)
            
                            DoScreenFadeIn(1500)
                        end, function()
                            QBCore.Functions.Notify("Canceled", "error", "1500")
                        end)
                        end
                    end)
                end
            end
        end
        Wait(sleep)
    end
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end