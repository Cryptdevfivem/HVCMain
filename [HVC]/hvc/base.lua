MySQL = module("hvc_mysql", "MySQL")

local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
local Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
local version = module("version")

local verify_card = {
    ["type"] = "AdaptiveCard",
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.3",
    ["backgroundImage"] = {
        ["url"] = "https://cdn.discordapp.com/attachments/876871120190599178/891413955854086154/hvc_banned.exe.png",
    },
    ["body"] = {
        {
            ["type"] = "TextBlock",
            ["text"] = "Welcome to HVC, to join our server please verify your discord account by following the steps below.",
            ["wrap"] = true,
            ["weight"] = "Bolder"
        },
        {
            ["type"] = "Container",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["text"] = "1. Join the HVC discord (discord.gg/hvc5m)",
                    ["wrap"] = true,
                },
                {
                    ["type"] = "TextBlock",
                    ["text"] = "2. In the #verify channel, type the following command",
                    ["wrap"] = true,
                },
                {
                    ["type"] = "TextBlock",
                    ["color"] = "Attention",
                    ["text"] = "3. !verify NULL",
                    ["wrap"] = true,
                }
            }
        },
        {
            ["type"] = "ActionSet",
            ["actions"] = {
                {
                    ["type"] = "Action.Submit",
                    ["title"] = "Enter HVC",
                    ["id"] = "attempt_connection"
                }
            }
        },
    }
}



Debug.active = config.debug
HVC = {}
Proxy.addInterface("HVC",HVC)

tHVC = {}
Tunnel.bindInterface("HVC",tHVC) -- listening for client tunnel

-- load language 
local dict = module("cfg/lang/"..config.lang) or {}
HVC.lang = Lang.new(dict)

-- init
HVCclient = Tunnel.getInterface("HVC","HVC") -- server -> client tunnel

HVC.users = {} -- will store logged users (id) by first identifier
HVC.rusers = {} -- store the opposite of users
HVC.user_tables = {} -- user data tables (logger storage, saved to database)
HVC.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
HVC.user_sources = {} -- user sources 
-- queries
Citizen.CreateThread(function()
    Wait(2500) -- Wait for GHMatti to Initialize
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS hvc_users(
    id INTEGER AUTO_INCREMENT,
    last_login VARCHAR(100),
    whitelisted BOOLEAN,
    banned BOOLEAN,
    bantime VARCHAR(100) NOT NULL DEFAULT "",
    banreason VARCHAR(1000) NOT NULL DEFAULT "",
    banadmin VARCHAR(100) NOT NULL DEFAULT "",
    CONSTRAINT pk_user PRIMARY KEY(id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS hvc_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
        CREATE TABLE IF NOT EXISTS hvc_user_tokens (
        token VARCHAR(200),
        user_id INTEGER,
        banned BOOLEAN  NOT NULL DEFAULT 0,
        CONSTRAINT pk_user_ids PRIMARY KEY(token)
        );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS hvc_user_data(
    user_id INTEGER,
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
    CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES hvc_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS hvc_srv_data(
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS hvc_user_moneys(
    user_id INTEGER,
    wallet INTEGER,
    bank INTEGER,
    CONSTRAINT pk_user_moneys PRIMARY KEY(user_id),
    CONSTRAINT fk_user_moneys_users FOREIGN KEY(user_id) REFERENCES hvc_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS hvc_user_moneys(
    user_id INTEGER,
    wallet INTEGER,
    bank INTEGER,
    CONSTRAINT pk_user_moneys PRIMARY KEY(user_id),
    CONSTRAINT fk_user_moneys_users FOREIGN KEY(user_id) REFERENCES hvc_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS hvc_user_business(
    user_id INTEGER,
    name VARCHAR(30),
    description TEXT,
    capital INTEGER,
    laundered INTEGER,
    reset_timestamp INTEGER,
    CONSTRAINT pk_user_business PRIMARY KEY(user_id),
    CONSTRAINT fk_user_business_users FOREIGN KEY(user_id) REFERENCES hvc_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS hvc_user_vehicles(
    user_id INTEGER,
    vehicle VARCHAR(100),
    vehicle_plate varchar(255) NOT NULL,
    CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle),
    CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES hvc_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS hvc_user_homes(
    user_id INTEGER,
    home VARCHAR(100),
    number INTEGER,
    CONSTRAINT pk_user_homes PRIMARY KEY(user_id),
    CONSTRAINT fk_user_homes_users FOREIGN KEY(user_id) REFERENCES hvc_users(id) ON DELETE CASCADE,
    UNIQUE(home,number)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS hvc_user_identities(
    user_id INTEGER,
    registration VARCHAR(100),
    phone VARCHAR(100),
    firstname VARCHAR(100),
    name VARCHAR(100),
    age INTEGER,
    CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
    CONSTRAINT fk_user_identities_users FOREIGN KEY(user_id) REFERENCES hvc_users(id) ON DELETE CASCADE,
    INDEX(registration),
    INDEX(phone)
    );
    ]])
    MySQL.SingleQuery("ALTER TABLE hvc_users ADD IF NOT EXISTS bantime varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE hvc_users ADD IF NOT EXISTS banreason varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE hvc_users ADD IF NOT EXISTS banadmin varchar(100) NOT NULL DEFAULT ''; ")
    MySQL.SingleQuery("ALTER TABLE hvc_user_vehicles ADD IF NOT EXISTS rented BOOLEAN NOT NULL DEFAULT 0;")
    MySQL.SingleQuery("ALTER TABLE hvc_user_vehicles ADD IF NOT EXISTS rentedid varchar(200) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE hvc_user_vehicles ADD IF NOT EXISTS rentedtime varchar(2048) NOT NULL DEFAULT '';")
    MySQL.createCommand("HVCls/create_modifications_column", "alter table hvc_user_vehicles add if not exists modifications text not null")
	MySQL.createCommand("HVCls/update_vehicle_modifications", "update hvc_user_vehicles set modifications = @modifications where user_id = @user_id and vehicle = @vehicle")
	MySQL.createCommand("HVCls/get_vehicle_modifications", "select modifications from hvc_user_vehicles where user_id = @user_id and vehicle = @vehicle")
    MySQL.createCommand("HVC/set_admintickets",[[
        INSERT INTO HVC_admintickets (UserID, Name, Tickets)
        VALUES( @user_id, @Name, @Tickets)
        ON DUPLICATE KEY UPDATE `Name` = @Name, `Tickets` = @Tickets
        ]])
	MySQL.execute("HVCls/create_modifications_column")
    print("Database tables initialized.")
end)







MySQL.createCommand("HVC/create_user","INSERT INTO hvc_users(whitelisted,banned) VALUES(false,false)")
MySQL.createCommand("HVC/add_identifier","INSERT INTO hvc_user_ids(identifier,user_id) VALUES(@identifier,@user_id)")
MySQL.createCommand("HVC/userid_byidentifier","SELECT user_id FROM hvc_user_ids WHERE identifier = @identifier")
MySQL.createCommand("HVC/identifier_all","SELECT * FROM hvc_user_ids WHERE identifier = @identifier")
MySQL.createCommand("HVC/select_identifier_byid_all","SELECT * FROM hvc_user_ids WHERE user_id = @id")

MySQL.createCommand("HVC/set_userdata","REPLACE INTO hvc_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
MySQL.createCommand("HVC/get_userdata","SELECT dvalue FROM hvc_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("HVC/set_srvdata","REPLACE INTO hvc_srv_data(dkey,dvalue) VALUES(@key,@value)")
MySQL.createCommand("HVC/get_srvdata","SELECT dvalue FROM hvc_srv_data WHERE dkey = @key")

MySQL.createCommand("HVC/get_banned","SELECT banned FROM hvc_users WHERE id = @user_id")
MySQL.createCommand("HVC/set_banned","UPDATE hvc_users SET banned = @banned, bantime = @bantime,  banreason = @banreason,  banadmin = @banadmin WHERE id = @user_id")
MySQL.createCommand("HVC/set_identifierbanned","UPDATE hvc_user_ids SET banned = @banned WHERE identifier = @iden")
MySQL.createCommand("HVC/getbanreasontime", "SELECT * FROM hvc_users WHERE id = @user_id")

MySQL.createCommand("HVC/get_whitelisted","SELECT whitelisted FROM hvc_users WHERE id = @user_id")
MySQL.createCommand("HVC/set_whitelisted","UPDATE hvc_users SET whitelisted = @whitelisted WHERE id = @user_id")
MySQL.createCommand("HVC/set_last_login","UPDATE hvc_users SET last_login = @last_login WHERE id = @user_id")
MySQL.createCommand("HVC/get_last_login","SELECT last_login FROM hvc_users WHERE id = @user_id")

--Token Banning 
MySQL.createCommand("HVC/add_token","INSERT INTO hvc_user_tokens(token,user_id) VALUES(@token,@user_id)")
MySQL.createCommand("HVC/check_token","SELECT user_id, banned FROM hvc_user_tokens WHERE token = @token")
MySQL.createCommand("HVC/check_token_userid","SELECT token FROM hvc_user_tokens WHERE user_id = @id")
MySQL.createCommand("HVC/ban_token","UPDATE hvc_user_tokens SET banned = @banned WHERE token = @token")
--Token Banning

-- init tables


-- identification system

--- sql.
-- cbreturn user id or nil in case of error (if not found, will create it)
function HVC.getUserIdByIdentifiers(ids, cbr)
    local task = Task(cbr)
    if ids ~= nil and #ids then
        local i = 0
        
        -- search identifiers
        local function search()
            i = i+1
            if i <= #ids then
                if not config.ignore_ip_identifier or (string.find(ids[i], "ip:") == nil) then  -- ignore ip identifier
                    MySQL.query("HVC/userid_byidentifier", {identifier = ids[i]}, function(rows, affected)
                        if #rows > 0 then  -- found
                            task({rows[1].user_id})
                        else -- not found
                            search()
                        end
                    end)
                else
                    search()
                end
            else -- no ids found, create user
                MySQL.query("HVC/create_user", {}, function(rows, affected)
                    if rows.affectedRows > 0 then
                        local user_id = rows.insertId
                        -- add identifiers
                        for l,w in pairs(ids) do
                            if not config.ignore_ip_identifier or (string.find(w, "ip:") == nil) then  -- ignore ip identifier
                                MySQL.execute("HVC/add_identifier", {user_id = user_id, identifier = w})
                            end
                        end
                        
                        task({user_id})
                    else
                        task()
                    end
                end)
            end
        end
        
        search()
    else
        task()
    end
end

-- return identification string for the source (used for non HVC identifications, for rejected players)
function HVC.getSourceIdKey(source)
    local ids = GetPlayerIdentifiers(source)
    local idk = "idk_"
    for k,v in pairs(ids) do
        idk = idk..v
    end
    
    return idk
end

function HVC.getPlayerEndpoint(player)
    return "0.0.0.0"
end

function HVC.getPlayerName(player)
    return GetPlayerName(player) or "unknown"
end

--- sql
-- This can only be used server side and is for the vRP bot. 
exports("HVCbot", function(method_name, params, cb)
    if cb then 
        cb(HVC[method_name](table.unpack(params)))
    else 
        return HVC[method_name](table.unpack(params))
    end
end)

function HVC.ReLoadChar(source)
    local name = GetPlayerName(source)
    local ids = GetPlayerIdentifiers(source)
    HVC.getUserIdByIdentifiers(ids, function(user_id)
        if user_id ~= nil then
            HVC.StoreTokens(source, user_id) 
            if HVC.rusers[user_id] == nil then -- not present on the server, init
                HVC.users[ids[1]] = user_id
                HVC.rusers[user_id] = ids[1]
                HVC.user_tables[user_id] = {}
                HVC.user_tmp_tables[user_id] = {}
                HVC.user_sources[user_id] = source
                HVC.getUData(user_id, "HVC:datatable", function(sdata)
                    local data = json.decode(sdata)
                    if type(data) == "table" then HVC.user_tables[user_id] = data end
                    local tmpdata = HVC.getUserTmpTable(user_id)
                    HVC.getLastLogin(user_id, function(last_login)
                        tmpdata.last_login = last_login or ""
                        tmpdata.spawns = 0
                        local ep = HVC.getPlayerEndpoint(source)
                        local last_login_stamp = ep.." "..os.date("%H:%M:%S %d/%m/%Y")
                        MySQL.execute("HVC/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                        print("[HVC Join] "..name.." Joined | PermID: "..user_id)
                        TriggerEvent("HVC:playerJoin", user_id, source, name, tmpdata.last_login)
                        TriggerClientEvent("HVC:CheckIdRegister", source)
                    end)
                end)
            else -- already connected
                print("[HVC] "..name.." Reconnected | PermID: "..user_id)
                TriggerEvent("HVC:playerRejoin", user_id, source, name)
                TriggerClientEvent("HVC:CheckIdRegister", source)
                local tmpdata = HVC.getUserTmpTable(user_id)
                tmpdata.spawns = 0
            end
        end
    end)
end

local user_id = 0
local MaxPlayers = GetConvarInt("sv_maxclients", 32)

RegisterNetEvent("HVC:CheckID")
AddEventHandler("HVC:CheckID", function()
    user_id = HVC.getUserId(source)
    TriggerClientEvent('discord:getpermid2', source, user_id)
    TriggerClientEvent('HVC:StartGetPlayersLoopCL', source)
    if not user_id then
        HVC.ReLoadChar(source)
    end
end)

RegisterNetEvent("HVC:StartGetPlayersLoopSV")
AddEventHandler("HVC:StartGetPlayersLoopSV", function()
    local UserID = HVC.getUserId(source)
    local PlayerCount = #GetPlayers()
    TriggerClientEvent('HVC:ReturnGetPlayersLoopCL', source, UserID, PlayerCount)
end)

function HVC.isBanned(user_id, cbr)
    local task = Task(cbr, {false})
    
    MySQL.query("HVC/get_banned", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].banned})
        else
            task()
        end
    end)
end

--- sql

--- sql
function HVC.isWhitelisted(user_id, cbr)
    local task = Task(cbr, {false})
    
    MySQL.query("HVC/get_whitelisted", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].whitelisted})
        else
            task()
        end
    end)
end

--- sql
function HVC.setWhitelisted(user_id,whitelisted)
    MySQL.execute("HVC/set_whitelisted", {user_id = user_id, whitelisted = whitelisted})
end

--- sql
function HVC.getLastLogin(user_id, cbr)
    local task = Task(cbr,{""})
    MySQL.query("HVC/get_last_login", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].last_login})
        else
            task()
        end
    end)
end

function HVC.fetchBanReasonTime(user_id,cbr)
    MySQL.query("HVC/getbanreasontime", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then 
            cbr(rows[1].bantime, rows[1].banreason, rows[1].banadmin)
        end
    end)
end

function HVC.setUData(user_id,key,value)
    MySQL.execute("HVC/set_userdata", {user_id = user_id, key = key, value = value})
end

function HVC.getUData(user_id,key,cbr)
    local task = Task(cbr,{""})
    
    MySQL.query("HVC/get_userdata", {user_id = user_id, key = key}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function HVC.setSData(key,value)
    MySQL.execute("HVC/set_srvdata", {key = key, value = value})
end

function HVC.getSData(key, cbr)
    local task = Task(cbr,{""})
    
    MySQL.query("HVC/get_srvdata", {key = key}, function(rows, affected)
        if rows and #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

-- return user data table for HVC internal persistant connected user storage
function HVC.getUserDataTable(user_id)
    return HVC.user_tables[user_id]
end

function HVC.getUserTmpTable(user_id)
    return HVC.user_tmp_tables[user_id]
end

function HVC.isConnected(user_id)
    return HVC.rusers[user_id] ~= nil
end

function HVC.isFirstSpawn(user_id)
    local tmp = HVC.getUserTmpTable(user_id)
    return tmp and tmp.spawns == 1
end

function HVC.getUserId(source)
    if source ~= nil then
        local ids = GetPlayerIdentifiers(source)
        if ids ~= nil and #ids > 0 then
            return HVC.users[ids[1]]
        end
    end
    
    return nil
end

-- return map of user_id -> player source
function HVC.getUsers()
    local users = {}
    for k,v in pairs(HVC.user_sources) do
        users[k] = v
    end
    
    return users
end

-- return source or nil
function HVC.getUserSource(user_id)
    return HVC.user_sources[user_id]
end

function HVC.IdentifierBanCheck(source,user_id,cb)
    for i,v in pairs(GetPlayerIdentifiers(source)) do 
        MySQL.query('HVC/identifier_all', {identifier = v}, function(rows)
            for i = 1,#rows do 
                if rows[i].banned then 
                    if user_id ~= rows[i].user_id then 
                        cb(true, rows[i].user_id)
                    end 
                end
            end
        end)
    end
end

function HVC.BanIdentifiers(user_id, value)
    MySQL.query('HVC/select_identifier_byid_all', {id = user_id}, function(rows)
        for i = 1, #rows do 
            MySQL.execute("HVC/set_identifierbanned", {banned = value, iden = rows[i].identifier })
        end
    end)
end

function HVC.setBanned(user_id,banned,reason,time, admin)
    if banned then 
        MySQL.execute("HVC/set_banned", {user_id = user_id, banned = banned, bantime = time, banreason = reason, banadmin = admin})
        HVC.BanIdentifiers(user_id, true)
        HVC.BanTokens(user_id, true) 
    else 
        MySQL.execute("HVC/set_banned", {user_id = user_id, banned = banned, bantime = "", banreason =  "", banadmin =  ""})
        HVC.BanIdentifiers(user_id, false)
        HVC.BanTokens(user_id, false) 
    end 
end




function HVC.ban(source,banReason,banTime,banAdmin)
    local user_id = HVC.getUserId(source)
    if user_id ~= nil then
      HVC.setBanned(user_id,true,banReason,banTime,banAdmin)
      local curtime = os.time()
      local seconds = tonumber(banTime)
      if seconds >= 3408178877 then
        banned_newtime = 'Permanent Ban'
      else
        local banned_newdate = banTime
        banned_newtime = 'Ban expires on: ' ..banTime.. ''
      end
      HVC.kick(source,"[HVC] \n"..banned_newtime.."\nYour ID is: "..user_id.."\nReason: "..banReason.."\nBanned by "..banAdmin.."\nIf You Believe This Is A False Ban, You Can Appeal It @ hvcforums.com")
    end
end


function banDiscord(PermID,banTime,Reason)
    if PermID ~= nil then
        CurrentTime = os.time()
        if tostring(banTime) == "-1" then
            CurrentTime = CurrentTime + (60 * 60 * 500000)
        else
            CurrentTime = CurrentTime + (60 * 60 * tonumber(banTime))
        end
        HVC.setBanned(PermID,true,Reason,CurrentTime,"HVC")
        local curtime = os.time()
        local seconds = tonumber(CurrentTime)
        if seconds >= 3408178877 then
            banned_newtime = 'Permanent Ban'
        else
            local banned_newdate = banTime
            banned_newtime = 'Ban expires on: ' ..banTime.. ''
        end
        if HVC.getUsers(PermID) then
            HVC.kick(HVC.getUsers(PermID),"[HVC] \n"..banned_newtime.."\nYour ID is: "..PermID.."\nReason: "..Reason.."\nBanned by HVC\nIf You Believe This Is A False Ban, You Can Appeal It @ hvcforums.com")
        end
    end
end

function HVC.BanUser(PlayerSource, BanReason, BanDuration, AdminName)

    local PlayerID = HVC.getUserId(PlayerSource)
    if PlayerID ~= nil then
        local CurrentTime = os.time()
        local Duration = tonumber(BanDuration)
        
        if AdminName == "HVC" or AdminName == "HVC Anticheat" then
            HVC.setBanned(PlayerID, true, BanReason, BanDuration, "HVC")
            HVC.kick(PlayerSource,"\n[HVC] You have been permanently banned\nYour ID is: "..PlayerID.."\nReason: Cheating ("..BanReason..")\nYou were banned by HVC\nYou can appeal @ hvcforums.com")
            return
        end

        if Duration >= 3408178877 or Duration == -1 then
            HVC.setBanned(PlayerID, true, BanReason, BanDuration, AdminName)
            HVC.kick(PlayerSource,"\n[HVC] You have been permanently banned\nYour ID is: "..PlayerID.."\nReason: "..BanReason.."\nYou were banned by " .. AdminName .. "\nYou can appeal @ hvcforums.com")
        else
            CurrentTime = os.time()
            BanRemainingSeconds = BanDuration - CurrentTime
            BanRemainingHours = BanRemainingSeconds / 3600
            BanRemainingRounded = math.floor(BanRemainingHours+0.5)
            HVC.setBanned(PlayerID, true, BanReason, BanDuration, AdminName)
            HVC.kick(PlayerSource,"\n[HVC] You have been temporarily banned \nDuration: " ..BanRemainingRounded.." hours\nYour ID is: "..PlayerID.."\nReason: "..BanReason.."\nYou were banned by " .. AdminName .. "\nYou can appeal @ hvcforums.com")
        end 
    end
end




exports("banDiscord", function(params, cb)
    banDiscord(tonumber(params[1]), tonumber(params[2]), params[3])
end)

exports("unbanDiscord", function(params, cb)
    HVC.setBanned(tonumber(params[1]),false,'','','')
end)



function HVC.offlineban(user_id,banReason,banTime,banAdmin)
    if user_id ~= nil then
        HVC.setBanned(user_id,true,banReason,banTime,banAdmin)
    end
end


-- To use token banning you need the latest artifacts.
function HVC.StoreTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            MySQL.query("HVC/check_token", {token = token}, function(rows)
                if token and rows and #rows <= 0 then 
                    MySQL.execute("HVC/add_token", {token = token, user_id = user_id})
                end        
            end)
        end
    end
end


function HVC.CheckTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local banned = false;
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            local rows = MySQL.asyncQuery("HVC/check_token", {token = token, user_id = user_id})
                if #rows > 0 then 
                if rows[1].banned then 
                    return rows[1].banned, rows[1].user_id
                end
            end
        end
    else 
        return false; 
    end
end

function HVC.BanTokens(user_id, banned) 
    if GetNumPlayerTokens then 
        MySQL.query("HVC/check_token_userid", {id = user_id}, function(id)
            for i = 1, #id do 
                MySQL.execute("HVC/ban_token", {token = id[i].token, banned = banned})
            end
        end)
    end
end


function HVC.kick(source,reason)
    DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
    TriggerEvent("HVC:save")
    
    Debug.pbegin("HVC save datatables")
    for k,v in pairs(HVC.user_tables) do
        HVC.setUData(k,"HVC:datatable",json.encode(v))
    end
    
    Debug.pend()
    SetTimeout(config.save_interval*1000, task_save_datatables)
end
task_save_datatables()

function save_datatables_on_leave()
    TriggerEvent("HVC:save")
    
    Debug.pbegin("HVC save datatables")
    for k,v in pairs(HVC.user_tables) do
        HVC.setUData(k,"HVC:datatable",json.encode(v))
    end
    print("HVC Saving datables on leave")
end

-- handlers
AddEventHandler("playerConnecting",function(name,setMessage, deferrals)
    deferrals.defer()
    
    local source = source
    Debug.pbegin("playerConnecting")
    local ids = GetPlayerIdentifiers(source)
    
    if ids ~= nil and #ids > 0 then
        deferrals.update("[HVC] Checking player identifiers...")
        HVC.getUserIdByIdentifiers(ids, function(user_id)
            local numtokens = GetNumPlayerTokens(source)
            print(GetPlayerName(source).. " Has " ..numtokens.. " Tokens " ..user_id)
            
            if numtokens == 0 then
                print("[HVC] User rejected for attempting to evade ID: " .. user_id .. " | (Ignore joined message, they were rejected)") 
                TriggerClientEvent("chatMessage", -1, "^1^*[HVC]", {180, 0, 0}, GetPlayerName(source) .. " Tried Evading Their Ban.")
                local banevadinglogs = "https://discord.com/api/webhooks/926665825803456523/44JD0MPZ134746vyFW9knlDmNRMzN5uHbJXplyNqlkkCawXjb4QCEQPV7yWWfISU2OHA"
                local communityname = "HVC Staff Logs"
                local communtiylogo = "https://cdn.discordapp.com/attachments/721345578075815966/892479760863756308/esreswrses.png" --Must end with .png or .jpg
                local curdate = os.time()
                curdate = curdate + (60 * 60 * 500000)
                local command = {
                    {
                        ["fields"] = {
                            {
                                ["name"] = "**Player Name**",
                                ["value"] = "" ..GetPlayerName(source),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player Source**",
                                ["value"] = "" ..source,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player PermID**",
                                ["value"] = "" ..user_id,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Token Amount**",
                                ["value"] = "" ..numtokens,
                                ["inline"] = true
                            },
                        },
                        ["color"] = "15536128",
                        ["title"] = GetPlayerName(source).. " Tried Evading Thier Ban",
                        ["description"] = "",
                        ["footer"] = {
                        ["text"] = communityname,
                        ["icon_url"] = communtiylogo,
                        },
                    }
                }

                PerformHttpRequest(banevadinglogs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
                HVC.setBanned(user_id,true,"Ban Evading", curdate, "HVC")
                deferrals.done("[HVC] Ban Evading Is Not Permitted, Your ID Is: " .. user_id .. "\nIf You Think This Is A Error, Please Join Our Teamspeak (ts.hvc.city)")
                return 
            end

            HVC.IdentifierBanCheck(source, user_id, function(status, id)
                if status then
                    print("[HVC] User rejected for attempting to evade ID: " .. user_id .. " | (Ignore joined message, they were rejected)") 
                    deferrals.done("[HVC] Ban Evading Is Not Permitted, Your ID Is: " .. id .. "\nIf You Think This Is A Error, Please Join Our Teamspeak\n[ts.hvc.city]")
                    return 
                end
            end)
            -- if user_id ~= nil and HVC.rusers[user_id] == nil then -- check user validity and if not already connected (old way, disabled until playerDropped is sure to be called)
            if user_id ~= nil then -- check user validity 
                deferrals.update("[HVC] Fetching player tokens..")
                HVC.StoreTokens(source, user_id) 
                deferrals.update("[HVC] Checking banned...")
                HVC.isBanned(user_id, function(banned)
                    if not banned then
                        deferrals.update("[HVC] Checking whitelisted...")
                        HVC.isWhitelisted(user_id, function(whitelisted)
                            if not config.whitelist or whitelisted then
                                Debug.pbegin("playerConnecting_delayed")
                                if HVC.rusers[user_id] == nil then -- not present on the server, init
                                    ::try_verify::
                                    local verified = exports["ghmattimysql"]:executeSync("SELECT * FROM verification WHERE user_id = @user_id", {user_id = user_id})
                                    if #verified > 0 then
                                        if verified[1]["verified"] == false then
                                            local code = nil
                                            local data_code = exports["ghmattimysql"]:executeSync("SELECT * FROM verification WHERE user_id = @user_id", {user_id = user_id})
                                            code = data_code[1]["code"]
                                            if code == nil then
                                                code = math.random(100000, 999999)
                                            end
                                            exports["ghmattimysql"]:executeSync("UPDATE verification SET code = @code WHERE user_id = @user_id", {user_id = user_id, code = code})
                                            local function show_auth_card(code, deferrals, callback)
                                                verify_card["body"][2]["items"][3]["text"] = "3. !verify "..code
                                                deferrals.presentCard(verify_card, callback)
                                            end
                                            local function check_verified()
                                                local data_verified = exports["ghmattimysql"]:executeSync("SELECT * FROM verification WHERE user_id = @user_id", {user_id = user_id})
                                                local verified_code = data_verified[1]["verified"]
                                                if verified_code == true then
                                                    if HVC.CheckTokens(source, user_id) then 
                                                        deferrals.done("[HVC] Ban Evading Is Not Permitted, Your ID Is: " .. id .. "\nIf You Think This Is A Error, Pleaes Join Our Teamspeak\n[ts.hvc.city]")
                                                    end
                                                    HVC.users[ids[1]] = user_id
                                                    HVC.rusers[user_id] = ids[1]
                                                    HVC.user_tables[user_id] = {}
                                                    HVC.user_tmp_tables[user_id] = {}
                                                    HVC.user_sources[user_id] = source
                                                    HVC.getUData(user_id, "HVC:datatable", function(sdata)
                                                        local data = json.decode(sdata)
                                                        if type(data) == "table" then HVC.user_tables[user_id] = data end
                                                        local tmpdata = HVC.getUserTmpTable(user_id)
                                                        HVC.getLastLogin(user_id, function(last_login)
                                                            tmpdata.last_login = last_login or ""
                                                            tmpdata.spawns = 0
                                                            local ep = HVC.getPlayerEndpoint(source)
                                                            local last_login_stamp = ep.." "..os.date("%H:%M:%S %d/%m/%Y")
                                                            MySQL.execute("HVC/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                            print("[HVC] "..name.." Joined | PermID: "..user_id..")")
                                                            TriggerEvent("HVC:playerJoin", user_id, source, name, tmpdata.last_login)
                                                            Wait(500)
                                                            deferrals.done()
                                                        end)
                                                    end)
                                                else
                                                    show_auth_card(code, deferrals, check_verified)
                                                end
                                            end
                                            show_auth_card(code, deferrals, check_verified)
                                        else
                                            if HVC.CheckTokens(source, user_id) then 
                                                deferrals.done("[HVC] Ban Evading Is Not Permitted, Your ID Is: " .. id .. "\nIf You Think This Is A Error, Pleaes Join Our Teamspeak\n[ts.hvc.city]")
                                            end
                                            HVC.users[ids[1]] = user_id
                                            HVC.rusers[user_id] = ids[1]
                                            HVC.user_tables[user_id] = {}
                                            HVC.user_tmp_tables[user_id] = {}
                                            HVC.user_sources[user_id] = source
                                            HVC.getUData(user_id, "HVC:datatable", function(sdata)
                                                local data = json.decode(sdata)
                                                if type(data) == "table" then HVC.user_tables[user_id] = data end
                                                local tmpdata = HVC.getUserTmpTable(user_id)
                                                HVC.getLastLogin(user_id, function(last_login)
                                                    tmpdata.last_login = last_login or ""
                                                    tmpdata.spawns = 0
                                                    local ep = HVC.getPlayerEndpoint(source)
                                                    local last_login_stamp = ep.." "..os.date("%H:%M:%S %d/%m/%Y")
                                                    MySQL.execute("HVC/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                    print("[HVC] "..name.." Joined | PermID: "..user_id..")")
                                                    TriggerEvent("HVC:playerJoin", user_id, source, name, tmpdata.last_login)
                                                    Wait(500)
                                                    deferrals.done()
                                                end)
                                            end)
                                        end
                                    else
                                        exports["ghmattimysql"]:executeSync("INSERT IGNORE INTO verification(user_id,verified) VALUES(@user_id,false)", {user_id = user_id})
                                        goto try_verify
                                    end

                                else -- already connected
                                    if HVC.CheckTokens(source, user_id) then 
                                        deferrals.done("[HVC Antievade] Ban Evading Is Not Permitted, Your ID Is: " .. id .. "\nIf You Think This Is A Error, Pleaes Join Our Teamspeak\n[ts.hvc.city]")
                                    end
                                    print("[HVC] "..name.." Reconnected | PermID: "..user_id)
                                    TriggerEvent("HVC:playerRejoin", user_id, source, name)
                                    Wait(500)
                                    deferrals.done()
                                    
                                    -- reset first spawn
                                    local tmpdata = HVC.getUserTmpTable(user_id)
                                    tmpdata.spawns = 0
                                end
                                
                                Debug.pend()
                            else
                                print("[HVC] "..name.." Rejected | Reason: Not Whitelisted | PermID: "..user_id)
                                deferrals.done("[HVC] "..name.." Rejected | Reason: Not Whitelisted | PermID: "..user_id)
                            end
                        end)
                    else
                        deferrals.update("[HVC] Fetching Tokens...")
                        HVC.StoreTokens(source, user_id) 
                        HVC.fetchBanReasonTime(user_id,function(bantime, banreason, banadmin)
                            if tonumber(bantime) then 
                                if bantime == -1 then
                                    deferrals.done("\n\n[HVC] Permanent Ban \nYour ID is: ".. user_id .."\nReason: " .. banreason .. "\nBanned by " .. banadmin .. "\nAppeal @ hvcforums.com")
                                else
                                    local timern = os.time()
                                    local banremainings = bantime - timern
                                    local banremainingt = banremainings / 3600
                                    local banremaining = math.floor(banremainingt+0.5)
                                    if banremaining > 40000 then
                                        deferrals.done("\n\n[HVC] Permanent Ban \nYour ID is: ".. user_id .."\nReason: " .. banreason .. "\nBanned by " .. banadmin .. "\nAppeal @ hvcforums.com")
                                        return
                                    else
                                        if timern > tonumber(bantime) then 
                                            deferrals.update('\nYour Ban Has Expired. \nConnecting To HVC...')
                                            Wait(1000)
                                            HVC.setBanned(user_id,false)
                                            if HVC.rusers[user_id] == nil then -- not present on the server, init
                                                -- init entries
                                                HVC.users[ids[1]] = user_id
                                                HVC.rusers[user_id] = ids[1]
                                                HVC.user_tables[user_id] = {}
                                                HVC.user_tmp_tables[user_id] = {}
                                                HVC.user_sources[user_id] = source
                                                
                                                deferrals.update("[HVC] Fetching Datatables...")
                                                HVC.getUData(user_id, "HVC:datatable", function(sdata)
                                                    local data = json.decode(sdata)
                                                    if type(data) == "table" then HVC.user_tables[user_id] = data end
                                                    
                                                    -- init user tmp table
                                                    local tmpdata = HVC.getUserTmpTable(user_id)
                                                    
                                                    deferrals.update("[HVC] Checking Ban Data...")
                                                    HVC.getLastLogin(user_id, function(last_login)
                                                        tmpdata.last_login = last_login or ""
                                                        tmpdata.spawns = 0
                                                        
                                                        -- set last login
                                                        local ep = HVC.getPlayerEndpoint(source)
                                                        local last_login_stamp = ep.." "..os.date("%H:%M:%S %d/%m/%Y")
                                                        MySQL.execute("HVC/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                        
                                                        -- trigger join
                                                        print("[HVC] "..name.." Joined After His Ban Expired | PermID: "..user_id)
                                                        TriggerEvent("HVC:playerJoin", user_id, source, name, tmpdata.last_login)
                                                        Wait(500)
                                                        deferrals.done()
                                                    end)
                                                end)
                                            else -- already connected
                                                print("[HVC] "..name.." Re-joined After His Ban Expired | PermID: "..user_id)
                                                TriggerEvent("HVC:playerRejoin", user_id, source, name)
                                                Wait(500)
                                                deferrals.done()
                                                
                                                -- reset first spawn
                                                local tmpdata = HVC.getUserTmpTable(user_id)
                                                tmpdata.spawns = 0
                                            end
                                            return 
                                        end
                                    end
                                    print("[HVC] "..name.." Rejected | Reason: Banned | PermID: "..user_id)
                                    deferrals.done("\n\n[HVC] Temporary Ban \nDuration: ".. banremaining .."\nYour ID is: ".. user_id .."\nReason: " .. banreason .. "\nBanned by " .. banadmin .. "\nAppeal @ hvcforums.com")
                                end
                            else 
                                print("[HVC] "..name.." Rejected | Reason: Banned | PermID: "..user_id)
                                deferrals.done("\n\n[HVC] Permanent Ban \nYour ID is: ".. user_id .."\nReason: " .. banreason .. "\nBanned by " .. banadmin .. "\nAppeal @ hvcforums.com")
                            end
                        end)
                    end
                end)
            else
                print("[HVC] "..name.." Rejected | Reason: Identification Error")
                deferrals.done("[HVC] Error Connecting\nReason: Missing Identifiers\nIf You Carry On Getting This Error Please Contact A Developer")
            end
        end)
    else
        print("[HVC] "..name.." Rejected | Reason: Missing Identifiers")
        deferrals.done("[HVC] Error Connecting\nReason: Missing Identifiers\nIf You Carry On Getting This Error Please Contact A Developer")
    end
    Debug.pend()
end)

AddEventHandler("playerDropped",function(reason)
    local source = source
    local user_id = HVC.getUserId(source)
    local data = HVC.getUserDataTable(user_id)
    if user_id ~= nil then

        TriggerEvent("HVC:playerLeave", user_id, source)
        print(reason)
        TriggerEvent("HVC:playerLeave2", user_id, source, reason)
        
        -- save user data table
        HVC.setUData(user_id,"HVC:datatable",json.encode(HVC.getUserDataTable(user_id)))
        HVC.users[HVC.rusers[user_id]] = nil
        HVC.rusers[user_id] = nil
        HVC.user_tables[user_id] = nil
        HVC.user_tmp_tables[user_id] = nil
        HVC.user_sources[user_id] = nil
        print('[HVC] Player Leaving Save:  Saved data for: ' .. GetPlayerName(source))
    else 
        print('[HVC] SEVERE ERROR: Failed to save data for: ' .. GetPlayerName(source) .. ' Rollback expected!')
    end
    HVCclient.removePlayer(-1,{source})
end)

RegisterServerEvent("HVCcli:playerSpawned")
AddEventHandler("HVCcli:playerSpawned", function()
    Debug.pbegin("playerSpawned")
    -- register user sources and then set first spawn to false
    local user_id = HVC.getUserId(source)
    local player = source
    if user_id ~= nil then
        HVC.user_sources[user_id] = source
        local tmp = HVC.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns+1
        local first_spawn = (tmp.spawns == 1)
        
        if first_spawn then
            -- first spawn, reference player
            -- send players to new player
            for k,v in pairs(HVC.user_sources) do
                HVCclient.addPlayer(source,{v})
            end
            -- send new player to all players
            HVCclient.addPlayer(-1,{source})
        end
        
        -- set client tunnel delay at first spawn
        --Tunnel.setDestDelay(player, config.load_delay)
        
        -- show loading
        HVCclient.setProgressBar(player,{"HVC:loading", "botright", "Loading...", 0,0,0, 100})
        
        SetTimeout(600, function() -- trigger spawn event
            TriggerEvent("HVC:playerSpawn",user_id,player,first_spawn)
            
            SetTimeout(config.load_duration*1000, function() -- set client delay to normal delay
                Tunnel.setDestDelay(player, config.global_delay)
                HVCclient.removeProgressBar(player,{"HVC:loading"})
            end)
        end)
    end
    
    Debug.pend()
end)

RegisterServerEvent("HVC:playerDied")


function HVC.OnlinePolice()
    local players = GetPlayers()
    local OnlinePolice = 0
    for i,v in pairs(players) do 
        name = GetPlayerName(v)
        user_id = HVC.getUserId(v)   
        if HVC.hasPermission(user_id, "police.menu") then
            OnlinePolice = OnlinePolice + 1
        end
    end
    return OnlinePolice
end

function HVC.OnlineStaff()
    local players = GetPlayers()
    local OnlineStaff = 0
    for i,v in pairs(players) do 
        name = GetPlayerName(v)
        user_id = HVC.getUserId(v)   
        if HVC.hasPermission(user_id, "admin.menu") then
            OnlineStaff = OnlineStaff + 1
        end
    end
    return OnlineStaff
end

function HVC.OnlineNHS()
    local players = GetPlayers()
    local OnlineNHS = 0
    for i,v in pairs(players) do 
        name = GetPlayerName(v)
        user_id = HVC.getUserId(v)   
        if HVC.hasPermission(user_id, "emscheck.revive") then
            OnlineNHS = OnlineNHS + 1
        end
    end
    return OnlineNHS
end

exports("GetOnline", function(params, cb)
    local Type = tostring(params[1])
    if Type == "Staff" then
        return HVC.OnlineStaff()
    elseif Type == "Police" then
        return HVC.OnlinePolice()
    elseif Type == "NHS" then
        return HVC.OnlineNHS()
    end
end)

exports("GetWhitelistedServer", function(params, cb)
    if config.whitelist then
        return "✅Enabled"
    elseif not config.whitelist then
        return "🛑Disabled"
    end
end)