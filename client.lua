local target = exports.ox_target
local onDuty = false
local BankPed = nil
local Targets = {}
local Till = {}
local time = 1000
local NPX = exports.rs_base:GetCoreObject()
local model = 'prop_till_03'

function loadModel(model) if not HasModelLoaded(model) then
	while not HasModelLoaded(model) do
		if time > 0 then time -= 1 RequestModel(model)
		else time = 1000 print("^5Debug^7: ^3LoadModel^7: ^2Timed out loading model ^7'^6"..model.."^7'") break
		end
		Wait(10)
	end
end end

function makeProp(data, freeze, synced)
    loadModel(data.prop)
    local prop = CreateObject(data.prop, data.coords.x, data.coords.y, data.coords.z, synced or false, synced or false, 0)
    SetEntityHeading(prop, data.coords.w+180.0)
    FreezeEntityPosition(prop, freeze or 0)
    if Config.Debug then print("^5Debug^7: ^6Prop ^2Created ^7: '^6"..prop.."^7'") end
    return prop
end

function unloadModel(model) 
    
    SetModelAsNoLongerNeeded(model) 
end

CreateThread(function()
	--Build Job/Gang Checks for cashin location
	--Build Job/Gang Checks for cashin location
	--Spawn Custom Cash Register Targets
	for k, v in pairs(Config.CustomCashRegisters) do
		for i = 1, #v do
			local job = k
			local gang = nil
			if v[i].gang then job = nil gang = k end
			Targets["CustomRegister: "..k..i] = target:addBoxZone({
                coords = v[i].coords.xyz, 0.47, 0.34,
                size = vec3(3, 3, 3),
                rotation = 45,
                debug = drawZones,
                drawSprite = true,
                options = {
                    {
                        name = 'pay1',
                        event = 'rs_payment:Payment',
                        icon = 'fa-solid fa-cube',
                        label = 'Koosta arve',
                    },
                }
            })
            Targets["CustomRegister: "..k..i] = target:addBoxZone({
                coords = v[i].coords.xyz, 0.47, 0.34,
                size = vec3(3, 3, 3),
                rotation = 45,
                debug = drawZones,
                drawSprite = true,
                options = {
                    {
                        name = 'pay2',
                        serverEvent = 'GetAll',
                        icon = 'fa-solid fa-cube',
                        label = 'Maksa arve',
                    },
                }
            })
			
			if v[i].prop then
				Till[#Till+1] = makeProp({prop = `prop_till_03`, coords = v[i].coords}, 1, false)
			end
		end
	end
end)


AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	unloadModel(model)
end)