const Discord = require('discord.js');
var Table = require('easy-table')
const client = new Discord.Client();

client.on('ready', () => {
    console.log(`Staff Bot Is Now Online:  ${client.user.tag}! ${GetNumPlayerIndices()}`);
});

function botStatus() {
    let statuses = ['HVC'];
    client.on('ready', () => {
        setInterval(function () {

            let status = statuses[Math.floor(Math.random() * statuses.length)];

            client.user.setPresence({ activity: { name: status }, status: 'online' });
        }, 10000)
    })
}

setInterval(function () {
    let totalSeconds = (client.uptime / 1000);
    totalSeconds %= 86400;
    let hours = Math.floor(totalSeconds / 3600);
    totalSeconds %= 3600;
    let minutes = Math.floor(totalSeconds / 60);
    client.user.setActivity(`${GetNumPlayerIndices()} Players`, { type: 'WATCHING' })
    let embed = {
        "color": 7063872,
        "timestamp": new Date(),
        "footer": {
            "text": "HVC"
        },
        "fields": [
            {
                "name": `Server Status`,
                "value": `✅Online`,
                "inline": true
            },
            {
                "name": `Response Time`,
                "value": `${MathRandomised(8, 27)}ms`, // Temp till i find an actual method 💤
                "inline": true
            },
            {
                "name": `Players`,
                "value": `${GetNumPlayerIndices()}/${GetConvarInt("sv_maxclients", 128)}`,
                "inline": true
            },
            {
                "name": `<:nhs:960273573778427924>NHS`,
                "value": `${exports.hvc.GetOnline(["NHS"])}`,
                "inline": true
            },
            {
                "name": `<:hvcpng:887099808622456872>Staff`,
                "value": `${exports.hvc.GetOnline(["Staff"])}`,
                "inline": true
            },
            {
                "name": `<:mpd:960273548369354764>Police`,
                "value": `${exports.hvc.GetOnline(["Police"])}`,
                "inline": true
            },
            {
                "name": `Uptime`,
                "value": `${hours} Hours, ${minutes} Minutes`,
                "inline": true
            },
            {
                "name": `Whitelist`,
                "value": `${exports.hvc.GetWhitelistedServer()}`,
                "inline": true
            },
        ],
        "description": "**How do I connect to the server?**\n`F8 ==> connect s1.hvc.city`",
        "title": "HVC Status"
    }
    client.channels.cache.get('900073282273959936').fetch('960264682134974544').then(messages => {
        messages.edit({ embed: embed })
    })
}, 15000)

function currency(val, width) {
    return Table.padLeft(val, 30)
}

function currency2(val, width) {
    return Table.padLeft(val, 15)
}

function currency3(val, width) {
    return Table.padLeft(val, 35)
}

client.awaitReply = async (msg, question, limit = 60000) => {
    const filter = m => m.author.id === msg.author.id;
    await msg.channel.send(question);
    try {
        const collected = await msg.channel.awaitMessages(filter, { max: 1, time: limit, errors: ["time"] });
        return collected.first().content;
    } catch (e) {
        return false;
    }
};

var prefix = "."
client.on('message', async message => {
    if (message.author.bot) return;
    var input = message.content.toLowerCase().split(" ")[0];
    if (!input.includes(prefix)) return;
    input = input.slice(prefix.length);
    var args = message.content.split(" ").slice(1);
    var joinargs = args.join(" ");
    let internet = joinargs.replace(/ /g, "+");


    if (input == "locklist") {
        message.reply('Check our current locklist here → https://docs.google.com/spreadsheets/d/1vu8UWG91NJtLvV0Uy9xH7jnAjnbd1KSllITmuy25wKk/edit?usp=sharing')
    }

    if (input == "carreport") {
        message.reply('Make a car report here → https://forms.gle/jYwhAWwHN6k6wYZh7')
    }

    if (input == "carresponses") {
        message.reply('Check our car report list here → https://docs.google.com/spreadsheets/d/1ci1UwCmm6gVkuijdiYzebgVJKkDgOc83tgF3kpRfwCE/edit#gid=1676952351')
    }

    if (input == "teamspeak") {
        message.reply('you can join our Teamspeak via → ts.hvc.city')
    }

    if (input == "ts") {
        message.reply('you can join our Teamspeak via → ts.hvc.city')
    }

    if (input == "forums") {
        message.reply('check out our forums via → https://hvcforums.com')
    }

    if (input == "donate") {
        message.reply('you can donate to HVC via → https://store.hvc.city')
    }

    if (input == "store") {
        message.reply('you can donate to HVC via → https://store.hvc.city')
    }

    if (input == "ip") {
        message.reply('connect to HVC → s1.hvc.city')
    }

    if (input == "connect") {
        message.reply('connect to HVC → s1.hvc.city')
    }
    if (input == "removecar") {
        if (message.member.roles.cache.some(r => r.name === "[Founder]") || message.member.roles.cache.some(r => r.name === "[Operations Manager]")) {
            if (args[0] && parseInt(args[0]) && args[1]) {
                exports.ghmattimysql.execute("SELECT * FROM hvc_user_vehicles WHERE user_id = ? and vehicle = ?", [args[0], args[1]], (result) => {
                    if (result.length > 0) { //Checking if user has vehicle.
                        exports.ghmattimysql.execute("DELETE FROM hvc_user_vehicles WHERE user_id = ? and vehicle = ?", [args[0], args[1]], (result) => {
                            if (result) {
                                message.reply(`Successfully removed ${args[1]} from ${args[0]}'s garage.`) //removed
                            }
                        })
                    } else {
                        message.reply(`Action failed, UserId ${args[0]} does not own ${args[1]}.`)//Doesn't own vehicle
                    }
                })
            } else {
                message.reply('Action failed, you must provide a Perm ID and a vehicle spawncode. Example -> (.removecar 1 taxi)') //invalid command usage
            }
        }
    }
    if (input == "money") {
        if (message.member.roles.cache.some(r => r.name === "[Founder]") || message.member.roles.cache.some(r => r.name === "[Operations Manager]")) {
            if (args[0] && parseInt(args[0])) {
                exports.ghmattimysql.execute("SELECT wallet,bank FROM hvc_user_moneys WHERE user_id = ?", [args[0]], (result) => {
                    var Bank = Format(result[0].bank)
                    var Wallet = Format(result[0].wallet)
                    let embed = {
                        "title": 'Money for User Id ' + args[0],
                        fields: [
                            {
                                name: 'Bank',
                                value: `${Bank}`,
                            },
                            {
                                name: "Wallet",
                                value: `${Wallet}`,
                            },
                        ],
                        "color": 16711680,
                        "footer": {
                            "text": "HVC Staff Bot"
                        },
                        "timestamp": new Date()
                    }
                    message.channel.send({ embed })
                });
            } else {
                message.reply('Action failed, you must provide a Perm ID. Example -> (.money PermID)')
            }
        }
    }
    if (input == "warnings") {
        if (message.member.roles.cache.some(r => r.name === "[Staff]")) {
            if (args[0] && parseInt(args[0])) {
                var text = ""
                exports.ghmattimysql.execute("SELECT * FROM `hvc_warnings` WHERE user_id = ?", [args[0]], (result) => {
                    //console.log(JSON.stringify(result), result.length);
                    var i;
                    for (i = 0; i < result.length; i++) {
                        var date = new Date(+result[i].warning_date)
                        text += `${result[i].duration}              ${result[i].user_id}              ${result[i].warning_type}              ${result[i].reason}              ${result[i].admin}              ${date.toDateString()}` + "\n";
                    }
                    var t = new Table
                    result.forEach(function (col) {
                        var date = new Date(+col.warning_date)
                        t.cell('User ID', col.user_id)
                        t.cell('Warning Type', col.warning_type)
                        t.cell('Duration: ', col.duration, currency2)
                        t.cell('Reason: ', col.reason, currency)
                        t.cell('Admin: ', col.admin, currency2)
                        t.cell('Date: ', date.toDateString(), currency3)
                        t.newRow()
                    })
                    message.channel.send(t.toString())
                    message.reply('They have: ' + result.length + ' Warning/s')
                });
            } else {
                message.reply('Please specify an PermID! E.G:  .warnings [permid]')
            }
        }
    }


    if (input == "tickets") {
        if (message.member.roles.cache.some(r => r.name === "[Staff Manager]") || message.member.roles.cache.some(r => r.name === "[Founder]") || message.member.roles.cache.some(r => r.name === "[Operations Manager]")) {

            if (args[0] && parseInt(args[0])) {
                var text = ""
                exports.ghmattimysql.execute("SELECT * FROM `hvc_admintickets` WHERE UserID = ?", [args[0]], (result) => {
                    var i;
                    for (i = 0; i < result.length; i++) {
                        var date = new Date(+result[i].warning_date)
                        text += `${result[i].Tickets}      ${result[i].UserID}     ${result[i].Name}             ${result[i].weeklyTickets}   ${result[i].admin}    ${date.toDateString()}` + "\n";
                    }
                    var t = new Table
                    result.forEach(function (col) {
                        var date = new Date(+col.warning_date)
                        t.cell('User ID', col.UserID)
                        t.cell('Name', col.Name)
                        t.cell('Tickets: ', col.Tickets, currency2)
                        t.cell('Weekly Tickets: ', col.weeklyTickets, currency)
                        t.newRow()
                    })
                    message.channel.send(t.toString())
                });
            } else {
                message.reply('Please specify an PermID! E.G:  .tickets [permid]')
            }
        }
    }

    if (input == "d2p") {
        if (message.member.roles.cache.some(r => r.name === "[Staff]")) {
            if (message.mentions.members.first()) {
                let user = message.mentions.members.first()
                exports.ghmattimysql.execute("SELECT * FROM `hvc_user_ids` WHERE identifier = ?", ["discord:" + user.id], (result) => {
                    if (result.length > 0) {
                        message.reply('PermID of this user is: ' + result[0].user_id)
                    } else {
                        message.reply('No account linked for this user.')
                    }
                });
            } else {
                message.reply('You need to mention someone!')
            }
        }
    }

    if (input == "checkban") {
        if (message.member.roles.cache.some(r => r.name === "[Staff]")) {

            exports.ghmattimysql.execute("SELECT * FROM `hvc_users` WHERE id = ?", [args[0]], (result) => {
                if (result) {
                    if (result[0].banned == 1) {
                        bandata = `**Banned**\nPlayer Is Banned\n\n**Reason**\n${result[0].banreason}\n\n**Banning Admin**\n${result[0].banadmin}\n\n**Ban Expires**\n${new Date(result[0].bantime * 1000)}`
                    } else {
                        bandata = '**User Is Not Banned**'
                    }
                    let embed = {
                        "title": 'Check Ban For PermID: ' + args[0],
                        "description": `${bandata}`,
                        "color": 6685692,
                        "footer": {
                            "text": "HVC Staff Bot • "
                        },
                        "timestamp": new Date()
                    }
                    message.channel.send({ embed })
                }
            })
        }
    }

    if (input == "p2d") {
        if (message.member.roles.cache.some(r => r.name === "[Staff]")) {
            if (args[0] && parseInt(args[0])) {
                exports.ghmattimysql.execute("SELECT * FROM `hvc_user_ids` WHERE user_id = ?", [args[0]], (result) => {
                    if (result.length > 0) {
                        console.log(JSON.stringify(result))
                        var i;
                        var text = ""
                        for (i = 0; i < result.length; i++) {
                            if (result[i].identifier.includes('discord')) {
                                message.reply('Discord of this user is: ' + "<@" + result[0].identifier.split(":")[1] + ">")
                            }
                        }
                    } else {
                        message.reply('No account linked for this user.')
                    }
                });
            } else {
                message.reply('You need to enter a valid PermID!')
            }
        }
    }

    if (input == "addcar") {
        if (message.member.roles.cache.some(r => r.name === "[Founder]") || message.member.roles.cache.some(r => r.name === "[Operations Manager]")) {
            if (args[0] && parseInt(args[0]) && args[1]) {

                exports.ghmattimysql.execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(?, ?)", [args[0], args[1]], (result) => {
                    if (result) {
                        message.reply('Vehicle has been added to the users garage!')
                    } else {
                        message.reply('Error, this vehicle is likely to already be owned by the player!')
                    }
                })
            } else {
                message.reply('You need to enter a valid PermID! Example: .addcar [permid] [car]')
            }
        }
    }
    if (input == "gco") {
        if (message.member.roles.cache.some(r => r.name === "[Staff]") || message.member.roles.cache.some(r => r.name === "[Champion]")) {
            if (args[0]) {
                let string = ""
                exports.ghmattimysql.execute("SELECT * FROM hvc_user_vehicles WHERE vehicle = ?", [args[0].toLowerCase()], (result) => {
                    if (result.length != 0) {
                        for (i = 0; i < result.length; i++) {
                            string = string + `${result[i].user_id} \n`
                        }
                        let embed = {
                            "color": 15280682,
                            "author": {
                                "name": "The current owners of: " + args[0],
                            },
                            "description": "```" + string + "```",
                            "footer": {
                                "text": 'HVC Bot',
                            },
                            "timestamp": new Date()
                        }
                        message.reply({ embed: embed })
                    } else {
                        message.reply(`No one currently owns ${args[0]}`)
                    }
                })
            }
        }
    }

    if (input == "ll") {
        if (message.member.roles.cache.some(r => r.name === "[Staff]")) {

            if (args[0]) {
                let string = ""
                exports.ghmattimysql.execute("SELECT * FROM hvc_users WHERE id = ?", [args[0].toLowerCase()], (result) => {
                    if (result) {

                        if (result) {
                            logdata = `**User last logged in:**\n${result[0].last_login}`

                        } else {
                            logdata = '**User has not logged in**'
                        }
                        for (i = 0; i < result.length; i++) {
                            string = string + `${result[i].user_id}, `
                        }
                        let embed = {
                            "color": 4886754,
                            "title": "Last Login: " + args[0],
                            "description": `${logdata.split('0.0.0.0')[1]}`,
                        }
                        message.reply({ embed: embed })
                    }
                })
            }
        }
    }


    if (input == "ch") {
        if (message.member.roles.cache.some(r => r.name === "[Staff]")) {

            if (args[0]) {
                let DiscordID = ""
                exports.ghmattimysql.execute("SELECT * FROM hvc_user_data WHERE user_id = ?", [args[0].toLowerCase()], (result) => {
                    if (result) {
                        let embed = {
                            "color": 4886754,
                            "title": "Hour Check On PermID: " + args[0],
                            "description": `PermID: ${args[0]} has played the server for ${Math.round(JSON.parse(result[0].dvalue).timePlayed / 3600)} hours`,
                        }
                        message.reply({ embed: embed })
                    }
                });
            }

        }
    }

    if (input == "gg") {
        if (message.member.roles.cache.some(r => r.name === "[Lead Developer]") || message.member.roles.cache.some(r => r.name === "[Founder]") || message.member.roles.cache.some(r => r.name === "[Administrator]") || message.member.roles.cache.some(r => r.name === "[Staff Manager]") || message.member.roles.cache.some(r => r.name === "[Senior Administrator]") || message.member.roles.cache.some(r => r.name === "[Operations Manager]")) {

            if (args[0]) {
                exports.ghmattimysql.execute("SELECT * FROM hvc_user_data WHERE user_id = ?", [args[0].toLowerCase()], (result) => {
                    if (result.length > 0) {
                        let embed = {
                            "title": "Fetched User Groups",
                            "description": `\n\nSuccess! Fetched Groups For UserId ${args[0]}\n\n` + "```" + JSON.stringify(JSON.parse(result[0].dvalue).groups) + "```",
                            "color": 5301186,

                            "timestamp": new Date()
                        }
                        message.channel.send({ embed })
                    } else {
                        message.reply('No groups for this user.')
                    }
                });
            }

        }
    }

    client.on("message", async message => {
        let blacklisted = ['KKK', 'steam', 'comminytu.com', 'stearn', 'eclipserp', 'eclipse', 'ape', 'nigger', 'nigga', 'paki', 'pak1', 'pakistani', 'coon', 'faggot', 'coonie', 'coony', 'wog', 'wogchamp', 'woggers', 'pog', 'pogchamp', 'poggers', 'chink', 'discorcl', 'freenitro', 'spoof', 'spoofer', '.ru', 'stearn', 'banevade', 'ban evade', 'evading', 'gay', 'dilscord'];

        let foundInText = false;
        for (var i in blacklisted) {
            if (message.content.toLowerCase().includes(blacklisted[i].toLowerCase())) foundInText = true;
        }

        if (foundInText) {
            message.delete();
            //message.channel.send("")
        }
    });


    if (input == "hmc") {
        if (message.member.roles.cache.some(r => r.name === "[Staff]") || message.member.roles.cache.some(r => r.name === "[Champion]")) {

            if (args[0]) {
                exports.ghmattimysql.execute("SELECT * FROM hvc_user_vehicles WHERE vehicle = ?", [args[0].toLowerCase()], (result) => {
                    if (result) {
                        message.reply(`There are: ${result.length} ${args[0]}'s in the city.`)
                    }
                })
            } else {
                message.reply('Incorrect command usage! .hmc [spawncode]')
            }
        }
    }

    if (input == "rulechange") {
        if (message.member.roles.cache.some(r => r.name === "[Founder]")) {

            if (args[0]) {
                message.client.send("Enter the main body of the announcement!")
            } else {
                message.reply('You do not have permission to do this command!')
            }
        }
    }

    if (input == "addweapon") {
        if (message.member.roles.cache.some(r => r.name === "[Founder]") || message.member.roles.cache.some(r => r.name === "[Lead Developer]")) {

            async function func() {
                let UserID = await client.awaitReply(message, 'What is the UserID you want to add the whitelist to?');
                let Shop = await client.awaitReply(message, 'What shop would you like to add the weapon to?');
                let Price = await client.awaitReply(message, 'What do you want the price to be?');
                let SpawnCode = await client.awaitReply(message, 'What is the weapon spawncode?');
                let WeaponName = await client.awaitReply(message, 'What is the weapon name?');
                let WeaponModel = await client.awaitReply(message, 'What is the weapon model?');

                exports.ghmattimysql.execute('INSERT INTO vrxith_whitelisted_weapons (UserID, Shop, Price, SpawnCode, WeaponName, WeaponModel) VALUES(?,?,?,?,?,?)', [UserID, Shop, Price, SpawnCode, WeaponName, WeaponModel])
                message.channel.send(`${message.author.mention} Added ${WeaponName} To ${UserID}'s ${Shop} Dealer For £${Price}!`)
            }
            func()
        }
    }

    if (input == "ban") {
        if (message.member.roles.cache.some(r => r.name === "[Administrator]") || message.member.roles.cache.some(r => r.name === "[Senior Administrator]") || message.member.roles.cache.some(r => r.name === "[Head Administrator]") || message.member.roles.cache.some(r => r.name === "[Staff Manager]") || message.member.roles.cache.some(r => r.name === "[Community Manager]") || message.member.roles.cache.some(r => r.name === "[Operations Manager]") || message.member.roles.cache.some(r => r.name === "[Lead Developer]") || message.member.roles.cache.some(r => r.name === "[Founder]")) {

            async function func() {
                let UserID = await client.awaitReply(message, 'What is the UserID you want to ban?');
                let Reason = await client.awaitReply(message, 'What is the reason for the ban?');
                let Time = await client.awaitReply(message, 'What is the time in hours for the ban?');
                exports.hvc.banDiscord([UserID, Time, Reason])
                message.reply('Banned User!')
            }
            func()
        }
    }

    if (input == "unban") {
        if (message.member.roles.cache.some(r => r.name === "[Senior Administrator]") || message.member.roles.cache.some(r => r.name === "[Head Administrator]") || message.member.roles.cache.some(r => r.name === "[Staff Manager]") || message.member.roles.cache.some(r => r.name === "[Community Manager]") || message.member.roles.cache.some(r => r.name === "[Operations Manager]") || message.member.roles.cache.some(r => r.name === "[Lead Developer]") || message.member.roles.cache.some(r => r.name === "[Founder]")) {
            async function func() {
                let UserID = await client.awaitReply(message, 'What is the UserID you want to unban?');
                exports.ghmattimysql.execute("SELECT * FROM `hvc_users` WHERE id = ?", [UserID], (User) => {
                    if (User) {
                        BanningAdmin = User[0].banadmin
                        if (BanningAdmin != "HVC") {
                            exports.hvc.unbanDiscord([parseInt(UserID)])
                            message.reply('Un-Banned User!')
                        } else {
                            var Current = new Date()
                            let embed = {
                                "color": 13573662,
                                "title": "HVC Unban",
                                "description": `Unban attempt failed due to the player being banned by Console/Anticheat.\nPlease message either a Founder or Developer to Unban this user.`,
                                "author": {
                                    "name": `HVC Staff Bot`,
                                    "icon_url": `${message.author.avatarURL}`
                                },
                                "footer": {
                                    "text": `User ID: ${UserID} - ${Current}`
                                }
                            }
                            message.channel.send({ embed: embed })
                        }
                    }
                });
            }
            func()
        }
    }
});

function Format(num) {
    return num.toLocaleString('en-UK', { style: 'currency', currency: 'GBP' });
}

function MathRandomised(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min) + min); //The maximum is exclusive and the minimum is inclusive
}


botStatus();
client.login("OTI2MjYzNjg4NzI4NTQzMjky.GyMf4i.g204eRCEhakIbhQIgBZGhncahM0kexBAt2sHJg");
