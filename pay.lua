local payment = {}




RegisterNetEvent('rs_payment:Payment', function()
    local src = source
    local dialog = lib.inputDialog('Make Payment', {
		-- title 1
		{type = 'input', label = 'Payment description', description = 'Enter title for payment'},
		-- identifier 2
		{type = 'number', label = 'Total', description = 'Price', icon = 'hashtag'},

        {type = 'number', label = 'ID', description = 'ID'},

        {type = "select",label = "Payment style",  options = {{ value = 'send', label = 'Send Payment' },{ value = 'make', label = 'Make Payment' }}}



	
	})

    if dialog then
        payment = dialog
        

        if payment[4] == 'send' then 
            TriggerServerEvent('rs_payment:SendPayment', payment[1], payment[2], payment[3])
        end
        if payment[4] == 'make' then
            TriggerServerEvent('rs_payment:MakePayment', payment[1], payment[2], payment[3])
        end
    end
end)


RegisterNetEvent('rs_payment:GetBills', function(bills)

    local data = bills

    if not data then 
        TriggerEvent('DoLongHudText', 'Pole arveid')
    end

    --print(json.encode(data[1].paid))

    if data then

        local menu = {}
        

        local catmenu = {}
        local categoryMenu = {}
    
        for k, v in pairs(data) do
            if type(data) == 'table' then
                
                catmenu[v] = v
                

            end
            
        end
        


    

        
        
        
        for k, v in pairs(catmenu) do
            categoryMenu[#categoryMenu + 1] = {
                title = 'Arve: '..v.detail,
                arrow = true,
                description = 'Staatus: '..v.paid..' Hind: '..v.amount..'$',
                serverEvent = 'PayBill',
                args = {
                    price = v.amount
                }
                    
                
            }
        end
        

    

        lib.registerContext({
            id = 'test',
            title = "Arved",
            menu = 'test',
            options = categoryMenu,
        })

        lib.showContext('test')
    else 
        menu = {}
    end
   
    
end)




