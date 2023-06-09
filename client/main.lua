----------------------------------------------------------------------------------
-- ESX = nil

-- Citizen.CreateThread(function()
    -- while ESX == nil do
        -- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        -- Citizen.Wait(0)
    -- end
-- end)
----------------------------------------------------------------------------------
_menuPool = NativeUI.CreatePool()
local isNearMoneyWash = false
----------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        isNearMoneyWash = false

        for k, v in pairs(Config.Location) do
            local distance = Vdist(playerCoords, v[1], v[2], v[3])

            if distance < 1.5 then
                isNearMoneyWash = true
            end
        end

        Citizen.Wait(350)
    end
end)
----------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do

        _menuPool:ProcessMenus()

        if isNearMoneyWash then
            showInfobar(Translation[Config.Locale]["press_menu"])
            

            if IsControlJustReleased(0, 38) then
                playAnim('mp_common', 'givetake1_a', Config.Animation.Time)
                openMoneyWash()
            end
        elseif _menuPool:IsAnyMenuOpen() then
            _menuPool:CloseAllMenus()
        end

        Citizen.Wait(1)
    end
end)
----------------------------------------------------------------------------------
function openMoneyWash()
    local moneyWashMenu = NativeUI.CreateMenu(Translation[Config.Locale]["menu_title"], Translation[Config.Locale]["menu_subtitle"])
    _menuPool:Add(moneyWashMenu)

    local washItem = NativeUI.CreateItem(Translation[Config.Locale]["wash_money"], Translation[Config.Locale]["wash_money_desc"])
    moneyWashMenu:AddItem(washItem)

    washItem.Activated = function(sender, index)

        local input = CreateDialog("Wie viel?")
        input = tonumber(input)
        if input ~= nil and input > 0 then
            TriggerServerEvent("moneywash:wash", input)
        end
    end

    moneyWashMenu:Visible(true)
    _menuPool:MouseEdgeEnabled(false)
end
----------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        for k, v in pairs(Config.Location) do
            DrawMarker(Config.MarkerType, v[1], v[2], v[3] - 1, 0, 0, 0, 0, 0, 0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, Config.MarkerColor.a, false, true, 2, nil, nil, false)
        end

        Citizen.Wait(1)
    end
end)
----------------------------------------------------------------------------------
function showInfobar(msg)
    CurrentActionMessage = msg
    SetTextComponentFormat("STRING")
    AddTextComponentString(CurrentActionMessage)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, true)
end

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

function CreateDialog(OnScreenDisplayTitle_shopmenu)
    AddTextEntry(OnScreenDisplayTitle_shopmenu, OnScreenDisplayTitle_shopmenu)
    DisplayOnscreenKeyboard(1, OnScreenDisplayTitle_shopmenu, "", "", "", "", "", 32)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local displayResult = GetOnscreenKeyboardResult()
        return displayResult
    end
end
----------------------------------------------------------------------------------