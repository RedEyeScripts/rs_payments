local NPX = exports.rs_base:GetCoreObject()


function GetBills()
    local src = source
    local player = NPX.Functions.GetPlayer(src)
    local citizenid = player.PlayerData.citizenid
    exports.oxmysql:execute('SELECT * FROM payments WHERE citizenid = ? AND paid = ?', {citizenid, 1}, function(data)
        if data then
            TriggerClientEvent('rs_payment:GetBills', data)
            --print(json.encode(data))
        end
    end)


end

RegisterNetEvent('GetAll', function()

    local src = source
    local player = NPX.Functions.GetPlayer(src)
    local citizenid = player.PlayerData.citizenid
    exports.oxmysql:execute('SELECT * FROM payments WHERE citizenid = ? AND paid = ?', {citizenid, 1}, function(data)
        if data then
            TriggerClientEvent('rs_payment:GetBills', src, data)
            --print(json.encode(data))
        end

    end)

end)



RegisterNetEvent('rs_payment:MakePayment', function(title, amount, id)
    local src = source 
    local target = NPX.Functions.GetPlayer(id)
    local cash = target.PlayerData.money['cash']
    if cash > amount then

        target.Functions.RemoveMoney('cash', amount)
        TriggerClientEvent('DoLongHudText', src, 'Teie kontolt eemaldati raha summas '.. amount..'$')

    end

    if not target then 
        TriggerClientEvent('DoLongHudText', source, 'Isikut pole olemas') 
    end
    if cash < amount then 
        TriggerClientEvent('DoLongHudText', target, 'Sul pole sularaha')
        TriggerClientEvent('DoLongHudText', source, 'Isikul pole raha') 
    end
end)

RegisterNetEvent('PayBill', function(price)
    local src = source

    local player = NPX.Functions.GetPlayer(src)
    local bank = player.PlayerData.money['bank']
    local amo = price.price
    print(amo)
    if bank >= amo then 
        player.Functions.RemoveMoney('bank', amo)
        TriggerClientEvent('DoLongHudText', source, 'Teie kontolt eemaldati raha summas'.. amo)
    end

    if bank < amo then 
        TriggerClientEvent('DoLongHudText', source, 'Teie kontol pole piisavalt raha'.. amo)
        TriggerClientEvent('DoLongHudText', source, 'Isikul pole raha'.. amo)
    end
    local citizenid = player.PlayerData.citizenid
    MySQL.update('UPDATE payments SET paid = ? WHERE citizenid = ? AND amount = ? AND paid = ?;', {
        '0',
        citizenid,
        amo,
        '1'

    })
    /*exports.oxmysql:update("UPDATE payments SET paid = :h, WHERE citizenid = :i AND amount = :g AND paid = :b;",{
        h = '0'
        i = citizenid,
        g = amo,
        b = 1,
    })*/
    --exports.oxmysql:execute('UPDATE payments SET paid = ?, WHERE citizenid = ? AND amount = ? AND paid = ?', {citizenid, amo, 1})
        


    
end)


RegisterNetEvent('rs_payment:SendPayment', function(title, amount, id)
    local src = source
    local target = NPX.Functions.GetPlayer(id)
    local cash = target.PlayerData.money['cash']
    local bank = target.PlayerData.money['bank']
    local citizenid = target.PlayerData.citizenid

    exports.oxmysql:execute("INSERT INTO `payments` (citizenid, detail, amount, paid) VALUES (:i, :s, :g, :b)",{
        i = citizenid,
        s = title,
        g = amount,
        b = 1,
    })
    print("HELLOOOOOOOOO")
end)


