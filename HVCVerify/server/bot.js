const discord = require("discord.js");
const mysql = require("mysql");
const client = new discord.Client();
const prefix = "!"
const connection = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "hvc"
});

//client.on("message", async message => {
//    if(message.author.bot)return;
//    if(message.channel.type === "dm")return;
//    if(message.content.indexOf(prefix) !== 0)return;
//    const args = message.content.slice(prefix.length).trim().split(/ +/g);
//    const command = args.shift().toLowerCase();
//
//    if(command === "r" || command === "z") {
//        message.reply("Your a dirty ||snick||er")
//    }
//});

client.on("message", async message => {
    if(message.author.bot)return;
    if(message.channel.type === "dm")return;
    if(message.channel.name === "verify"){
        message.delete();
    }
//    if (message.author.id === `952960674219298866`) {
//        message.delete();
//    }
});

client.on("message", async message => {
    if(message.author.bot)return;
    if(message.channel.type === "dm")return;
    if(message.content.indexOf(prefix) !== 0)return;
    const args = message.content.slice(prefix.length).trim().split(/ +/g);
    const command = args.shift().toLowerCase();

    const guild = client.guilds.cache.get(`1071225849455579206`);
    if (! guild) return console.error("404: guild with ID", guildID, "not found");


    const member = guild.members.cache.get(message.author.id);
    if (! member) return console.error("404: user with ID", userID, "not found in guild", guild.name);

    if(command === "verify"){
        if(!args[0]){
            let embed = new discord.MessageEmbed()
            .setDescription(`:x: Invalid command usage \`${prefix}verify [code]\``)
            message.channel.send(embed).then(message => {
                return message.delete({ timeout: 5 * 1000 });
            });
        }
        connection.query(`SELECT * FROM verification WHERE code = '${args[0]}'`, function(error, results){
            if(error)console.log(error);
            if(results[0] === undefined){
                let embed = new discord.MessageEmbed()
                .setDescription(`:x: That code was invalid make sure you have a valid code.`)
                message.channel.send(embed).then(message => {
                    message.delete({ timeout: 5 * 1000 });
                });
            }else{
                connection.query(`UPDATE verification SET verified = 1 WHERE code = '${args[0]}'`, function(error){ 
                    if(error)console.log(error);
                });
                connection.query(`UPDATE verification SET discord_id = ${message.author.id} WHERE code = '${args[0]}'`, function(error){ 
                    if(error)console.log(error); 
                });
                connection.query(`UPDATE verification SET code = null WHERE discord_id = '${message.author.id}'`, function(error){ 
                    if(error)console.log(error); 
                });
                let embed = new discord.MessageEmbed()
                .setDescription(`:white_check_mark: Great your verified, head back in game and press connect.`)
                message.channel.send(embed).then(message => {
                    message.delete({ timeout: 5 * 1000 });
                });
                member.roles.add("1071228838631178251").then().catch(console.error);
            }
        });
    }
});

client.login("MTA3MTIyOTc3MjEzMjI2NjAxNA.GcbV6E.o3wkvv5awFe4wze7w94R3BvvzWJPnek_QDP7zI");