local text1 = "Server Restarting In 30 Minutes"
local text2 = "Server Restarting In 15 Minutes"
local text3 = "Server Restarting In 5 Minutes"
local text4 = "Restarting..."

RegisterServerEvent("restart:checkreboot")

AddEventHandler('restart:checkreboot', function()
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1


	if date_local == '23:30:00' then
		TriggerClientEvent('chatMessage', -1, "^*HVC", {255, 0, 0}, text1, 'alert')
    elseif date_local == '23:45:00' then
        TriggerClientEvent('chatMessage', -1, "^*HVC", {255, 0, 0}, text2, 'alert')
    elseif date_local == '23:55:00' then
        TriggerClientEvent('chatMessage', -1, "^*HVC", {255, 0, 0}, text3, 'alert')
    elseif date_local == '23:58:40' then
        TriggerClientEvent('chatMessage', -1, "^*HVC", {255, 0, 0}, text4, 'alert')
        DropPlayer(-1, "[HVC] Server Restarting, Please Reconnect Shortly")
		
	elseif date_local == '11:30:00' then
		TriggerClientEvent('chatMessage', -1, "^*HVC", {255, 0, 0}, text1, 'alert')
    elseif date_local == '11:45:00' then
        TriggerClientEvent('chatMessage', -1, "^*HVC", {255, 0, 0}, text2, 'alert')
    elseif date_local == '11:55:00' then
        TriggerClientEvent('chatMessage', -1, "^*HVC", {255, 0, 0}, text3, 'alert')
    elseif date_local == '11:49:58' then
        TriggerClientEvent('chatMessage', -1, "^*HVC", {255, 0, 0}, text4, 'alert')
    elseif date_local == '11:58:40' then
        TriggerClientEvent('chatMessage', -1, "^*HVC", {255, 0, 0}, text4, 'alert')
        DropPlayer(-1, "[HVC] Server Restarting, Please Reconnect Shortly")
    end
end)

function restart_server()
	SetTimeout(1000, function()
		TriggerEvent('restart:checkreboot')
		restart_server()
	end)
end
restart_server()
