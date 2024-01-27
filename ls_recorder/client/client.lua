local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local isRecording = false
local canRecord = true
local alreadyDead = false
local keybindsActive = false
local lastHealth = 0

RegisterCommand('ls_rdm:SaveRecording', function()
    if keybindsActive then
        DisablePrompt()
        StopRecordingAndSaveClip()
        isRecording = false
    end
end)

RegisterCommand('ls_rdm:StopRecording', function()
    if keybindsActive then
        DisablePrompt()
        StopRecordingAndDiscardClip()
        isRecording = false
    end
end)

RegisterKeyMapping('ls_rdm:SaveRecording', '.Save Recording', 'keyboard', 'e')
RegisterKeyMapping('ls_rdm:StopRecording', '.Stop Recording', 'keyboard', 'j')

function TriggerRecording(message)
    local startKeybind = GetKeyLabel(GetHashKey('ls_rdm:SaveRecording'))
    local endKeybind = GetKeyLabel(GetHashKey('ls_rdm:StopRecording'))

    if Config.displayTooltips and #message > 0 then
        ShowTooltip(message)
    end

    isRecording = true
    keybindsActive = true
    StartRecording(1)
    local isPromptEnabled = false
    local targetTime = GetGameTimer() + 25000

    while targetTime > GetGameTimer() and isRecording do
        if not isPromptEnabled and targetTime - GetGameTimer() <= 6000 then
            EnablePrompt(startKeybind, endKeybind)
            isPromptEnabled = true
        end

        Citizen.Wait(1)
    end

    Citizen.Wait(1000)

    keybindsActive = false
    isRecording = false
    StopRecordingAndDiscardClip()
    DisablePrompt()

end

Citizen.CreateThread(function()
    local wasPedDead = false

    while true do
        if IsPedDeadOrDying(PlayerPedId()) then
            canRecord = false
            StopRecordingAndDiscardClip()
            isRecording = false
            wasPedDead = true
        end

        if wasPedDead and not IsPedDeadOrDying(PlayerPedId()) then
            StopRecordingAndDiscardClip()
            wasPedDead = false
        end

        Citizen.Wait(1000)
    end
end)

function IsPlayerLosingHealth(player)
    local currentHealth = GetEntityHealth(player)

    if currentHealth < lastHealth then
        lastHealth = currentHealth
        return true
    else
        lastHealth = currentHealth
        return false
    end
end

local count = 0
Citizen.CreateThread(function()
    Citizen.Wait(1000)

    while true do
        local sleep = 300
        local players = CheckForPlayersInRange(200.0)

        if not isRecording and canRecord then
            if #players > 0 then
                if settingsTable['Gun'] and DangerCheck(players) then
                    TriggerRecording(L('Recording started due to Gun danger'))

                    lastHealth = GetEntityHealth(PlayerPedId())
                end
            end

            if settingsTable['Injured'] and IsPlayerLosingHealth(PlayerPedId()) and not IsPedDeadOrDying(PlayerPedId()) then
                TriggerRecording(L('Recording started due to Injury'))
            end

            if settingsTable['Falling'] and IsPlayerProperlyFalling(PlayerPedId()) then
                TriggerRecording(L('Recording started due to Falling'))

                -- prevents double recording from fall injury
                lastHealth = GetEntityHealth(PlayerPedId())
            end

            if settingsTable['Speeding'] and IsPlayerDrivingRecklessly(PlayerPedId()) then
                TriggerRecording(L('Recording started due to Reckless driving'))
            end

            if CustomEvent() then
                TriggerRecording()
            end
        end

        Citizen.Wait(sleep)
    end
end)

function IsPlayerProperlyFalling(ped)
    for k = 1, 5, 1 do
        local isRagdoll = IsPedRagdoll(ped)
        local isFalling = IsPedFalling(ped)
        local velocity = GetEntityVelocity(ped)
        local verticalSpeed = velocity.z

        if not (isRagdoll or isFalling) or verticalSpeed >= -1.0 then
            return false
        end

        Citizen.Wait(300)
    end

    return true
end

function IsPlayerDrivingRecklessly(player)
    local playerSpeed = GetEntitySpeed(player)

    if Config.units == 'mph' then
        playerSpeed = playerSpeed * 2.236936
    else
        playerSpeed = playerSpeed * 3.6
    end

    if playerSpeed >= Config.speed.threshold then
        return true
    end

    return false
end

-- Keep this function for other player who can threaten client
function DangerCheck(playerTable)
    local localPlayer = PlayerPedId()

    for k, playerId in pairs(playerTable) do
        local playerPed = GetPlayerPed(playerId)

        if IsPlayerGunThreat(playerId, GetPlayerServerId(playerId)) then
            return true
        end

        if Config.pedArmedRecording and IsPedArmed(GetPlayerPed(playerId)) then
            return true
        end
    end
end

function IsPlayerGunThreat(player, playerServerId)
    local ped = GetPlayerPed(player)
    local otherPed = GetPlayerPed(playerServerId)

    if IsPlayerFreeAiming(playerServerId) or IsPedShooting(ped) or IsPedShooting(otherPed) then
        return true
    end

    if Config.pedArmedRecording and IsPedArmed(otherPed) then
        return true
    end

    return false
end

function CheckForPlayersInRange(radiusSize)
    return UseCache('playersInRange', function()
        local playersInRange = {}
        local playerIdTable = GetActivePlayers()
        local localPlayer = PlayerPedId()
        local localPlayerCoords = GetEntityCoords(localPlayer)

        for k, playerId in pairs(playerIdTable) do
            local playerPed = GetPlayerPed(playerId)
            local playerCoords = GetEntityCoords(playerPed)
            local distance = GetDistanceBetweenCoords(localPlayerCoords.x, localPlayerCoords.y, localPlayerCoords.z, playerCoords.x, playerCoords.y, playerCoords.z, false)

            if distance < radiusSize then
                table.insert(playersInRange, playerId)
            end
        end

        return playersInRange
    end, 1000)
end

