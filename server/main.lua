----------------------------------------------------------------------------------
-- ESX = nil
-- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
----------------------------------------------------------------------------------
RegisterServerEvent("moneywash:wash")
AddEventHandler("moneywash:wash", function(amount)

    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getAccount("black_money").money >= amount then
        xPlayer.removeAccountMoney('black_money', amount)
        xPlayer.addAccountMoney('money', math.floor(amount / 1.5))
        xPlayer.showNotification("~r~" .. amount .. "$ Schwarzgeld~s~ wurden in ~g~" .. math.floor(amount / 1.5) .. "$ ~s~sauberes Geld gewaschen.")
    else
        xPlayer.showNotification("~r~Nicht genügend Schwarzgeld!")
    end
end)
----------------------------------------------------------------------------------