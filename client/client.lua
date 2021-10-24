local menuOpen = false

local function DrawText3D(x, y, z, text)
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

CreateThread(function()
    while true do
        sleep = 1000
    if Config.Draw3D then
        if LocalPlayer.state['isLoggedIn'] then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local currentTeleport = 1
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
        end
    else -- edit hereedit hereedit hereedit hereedit hereedit hereedit hereedit hereedit hereedit hereedit hereedit hereedit hereedit hereedit hereedit hereedit hereedit here
        if LocalPlayer.state['isLoggedIn'] then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local currentTeleport = 1
        for k, v in pairs(Config.Teleports["lower"]) do
            local dist = #(pos - vector3(v.x, v.y, v.z))
            if dist < 1.5 then
                sleep = 7
                TriggerEvent('elevator:client:openmenu', "up", "upper")
            end
        end

        for k, v in pairs(Config.Teleports["upper"]) do
            local dist = #(pos - vector3(v.x, v.y, v.z))
            if dist < 1.5 then
                sleep = 7
                TriggerEvent('elevator:client:openmenu', "down", "lower")
            end
            RegisterNetEvent('elevator:client:useElevator', function(data)
                if data.which == "upper" then
                DoScreenFadeOut(1500)
                while not IsScreenFadedOut() do
                    Wait(10)
                end
            
                currentTeleport = k
            
                local coords = Config.Teleports["upper"][currentTeleport]
                SetEntityCoords(ped, coords.x, coords.y, coords.z, 0, 0, 0, false)
                SetEntityHeading(ped, coords.w)
            
                Wait(1500)
            
                DoScreenFadeIn(1000)
        elseif data.which == "lower" then
            DoScreenFadeOut(1500)
            while not IsScreenFadedOut() do
                Wait(10)
            end
        
            currentTeleport = k
        
            local coords = Config.Teleports["lower"][currentTeleport]
            SetEntityCoords(ped, coords.x, coords.y, coords.z, 0, 0, 0, false)
            SetEntityHeading(ped, coords.w)
        
            Wait(1500)
        
            DoScreenFadeIn(1000)
        end
            end)
        end
        end
    end
    Wait(sleep)
    end
end)
    
    RegisterNetEvent('elevator:client:openmenu', function(updown, updown2)
        if not menuOpen then
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
        menuOpen = true
        Wait(2500)
        menuOpen = false
    end
    end)