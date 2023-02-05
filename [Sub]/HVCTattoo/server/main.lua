CreateThread(function()
    MySQL.Async.execute("CREATE TABLE IF NOT EXISTS tattoos (identifier varchar(100), tattoos longtext, PRIMARY KEY(identifier));")
end)

RegisterNetEvent("Mx :: GetTattoos")
AddEventHandler("Mx :: GetTattoos", function()
    local idJ = source
    local license = GetLicenseFiveM(idJ)

    MySQL.Async.fetchAll("SELECT * FROM tattoos where identifier = @identifier",
    {['@identifier'] = license},
    function(result)
        if result and #result > 0 then
            for i,k in pairs(result) do
                k.tattoos = json.decode(k.tattoos)
            end
            TriggerClientEvent("Mx :: TattoosGeted", idJ, result[1].tattoos)
        else
            TriggerClientEvent("Mx :: TattoosGeted", idJ, {})
        end
    end)  
end)

RegisterNetEvent("Mx :: RegisterTattoos")
AddEventHandler("Mx :: RegisterTattoos", function(tattoos, total_price, free)
    local idJ = source
    local license = GetLicenseFiveM(idJ)
    local MoneyPlayer = 0

    if (total_price == 0 or MoneyPlayer == 0 or MoneyPlayer >= total_price) or free then
        MySQL.Async.execute('UPDATE tattoos SET tattoos = @tattoos WHERE identifier = @identifier', {
            ['@tattoos'] = json.encode(tattoos), 
            ['@identifier'] = license
        }, function (rows)
            if rows == 0 then
                MySQL.Async.execute('INSERT INTO tattoos (identifier, tattoos) VALUES (@identifier, @tattoos)', {
                    ['@identifier'] = license,
                    ['@tattoos'] = json.encode(tattoos)
                }, function (rows)
                    if not free then 
                        -- Insert your function to remove money here (variable: total_price)
                    end
                    TriggerClientEvent("Mx :: ClosedStore", idJ, tattoos, total_price)
                end)
            else
                if not free then 
                    -- Insert your function to remove money here (variable: total_price)
                end
                TriggerClientEvent("Mx :: ClosedStore", idJ, tattoos, total_price)
            end
        end)
    else
        TriggerClientEvent("Mx :: ClosedStore", idJ, -1, -1)
    end
end)

function GetLicenseFiveM(source)
    local licenca = GetPlayerIdentifiers(source)
    for _, v in pairs(licenca) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            licenca = v
            break
        end
    end 
    return licenca
end