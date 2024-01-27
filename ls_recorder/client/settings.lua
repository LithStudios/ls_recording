settingsTable = {}

RegisterCommand('settings', function()
    SendNUIMessage({
        event = 'openSettings'
    })
    SetNuiFocus(true, true)
end)

function RetrieveJSONSettings()
    SendNUIMessage({
        event = 'initialize'
    })
end

RegisterNUICallback('retrieveSettings', function(data, cb)
    settingsTable = data.settings
    cb(true)

    SetNuiFocus(false,false)
end)


function EnablePrompt(startKeybind, endKeybind)
    SendNUIMessage({
        event = 'enablePrompt',
        startKeybind = startKeybind or 'unknown',
        endKeybind = endKeybind or 'unknown',
    })
end

function DisablePrompt()
    SendNUIMessage({
        event = 'disablePrompt'
    })
end