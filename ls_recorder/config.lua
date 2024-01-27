Config = {}

-- Keybind for interacting with objects eg. "Press E to look at menu"
Config.keybind = 'E'

Config.speed = {
    units = 'mph', -- mph or kmh
    threshold = 150
}

--Displays a tooltip to player with a reason why recording got triggered eg. falling, shots fired
Config.displayTooltips = true

--Enable this if recording should be triggered if client has "GUN" option and enabled
--and there is another player that has a gun in their hands
Config.pedArmedRecording = false

-- Input the animation that player is put in when they die
Config.deathAnimation = ''

--- LOCALE
-- To translate the messages edit the message on the right side! Not the message between the square brackets
Locale = {
    ['Recording started due to Gun danger'] = 'Recording started due to Gun danger',
    ['Recording started due to Injury'] = 'Recording started due to Injury',
    ['Recording started due to Falling'] = 'Recording started due to Falling',
    ['Recording started due to Reckless driving'] = 'Recording started due to Reckless driving'
}
