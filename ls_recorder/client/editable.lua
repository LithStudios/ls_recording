
-- Add your own code here to trigger the recording
function CustomEvent()
    --if something then
    --    return true
    --end

    return false
end

-- This function is responsible for all the tooltips displayed on top right of the screen, you could
-- replace it with a custom notification etc.
function ShowTooltip(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    EndTextCommandDisplayHelp(0, 0, 0, -1)
end

function Contains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function Debug(message)
    if Config.debug then
        print(message)
    end
end


function L(text)
    if Locale and Locale[text] then
        return Locale[text]
    end

    return text
end

local specialkeyCodes = {
    ['b_100'] = 'LMB', -- Left Mouse Button
    ['b_101'] = 'RMB', -- Right Mouse Button
    ['b_102'] = 'MMB', -- Middle Mouse Button
    ['b_103'] = 'Mouse.ExtraBtn1',
    ['b_104'] = 'Mouse.ExtraBtn2',
    ['b_105'] = 'Mouse.ExtraBtn3',
    ['b_106'] = 'Mouse.ExtraBtn4',
    ['b_107'] = 'Mouse.ExtraBtn5',
    ['b_108'] = 'Mouse.ExtraBtn6',
    ['b_109'] = 'Mouse.ExtraBtn7',
    ['b_110'] = 'Mouse.ExtraBtn8',
    ['b_115'] = 'MouseWheel.Up',
    ['b_116'] = 'MouseWheel.Down',
    ['b_130'] = 'NumSubstract',
    ['b_131'] = 'NumAdd',
    ['b_134'] = 'Num Multiplication',
    ['b_135'] = 'Num Enter',
    ['b_137'] = 'Num1',
    ['b_138'] = 'Num2',
    ['b_139'] = 'Num3',
    ['b_140'] = 'Num4',
    ['b_141'] = 'Num5',
    ['b_142'] = 'Num6',
    ['b_143'] = 'Num7',
    ['b_144'] = 'Num8',
    ['b_145'] = 'Num9',
    ['b_170'] = 'F1',
    ['b_171'] = 'F2',
    ['b_172'] = 'F3',
    ['b_173'] = 'F4',
    ['b_174'] = 'F5',
    ['b_175'] = 'F6',
    ['b_176'] = 'F7',
    ['b_177'] = 'F8',
    ['b_178'] = 'F9',
    ['b_179'] = 'F10',
    ['b_180'] = 'F11',
    ['b_181'] = 'F12',
    ['b_182'] = 'F13',
    ['b_183'] = 'F14',
    ['b_184'] = 'F15',
    ['b_185'] = 'F16',
    ['b_186'] = 'F17',
    ['b_187'] = 'F18',
    ['b_188'] = 'F19',
    ['b_189'] = 'F20',
    ['b_190'] = 'F21',
    ['b_191'] = 'F22',
    ['b_192'] = 'F23',
    ['b_193'] = 'F24',
    ['b_194'] = 'Arrow Up',
    ['b_195'] = 'Arrow Down',
    ['b_196'] = 'Arrow Left',
    ['b_197'] = 'Arrow Right',
    ['b_198'] = 'Delete',
    ['b_199'] = 'Escape',
    ['b_200'] = 'Insert',
    ['b_201'] = 'End',
    ['b_210'] = 'Delete',
    ['b_211'] = 'Insert',
    ['b_212'] = 'End',
    ['b_1000'] = 'Shift',
    ['b_1002'] = 'Tab',
    ['b_1003'] = 'Enter',
    ['b_1004'] = 'Backspace',
    ['b_1009'] = 'PageUp',
    ['b_1008'] = 'Home',
    ['b_1010'] = 'PageDown',
    ['b_1012'] = 'CapsLock',
    ['b_1013'] = 'Control',
    ['b_1014'] = 'Right Control',
    ['b_1015'] = 'Alt',
    ['b_1055'] = 'Home',
    ['b_1056'] = 'PageUp',
    ['b_2000'] = 'Space'
}

function GetKeyLabel(commandHash)
    local key = GetControlInstructionalButton(0, commandHash | 0x80000000, true)
    if string.find(key, 't_') then
        local label, _count = string.gsub(key, 't_', '')
        return label
    else
        return specialkeyCodes[key] or 'unknown'
    end
end