const Discord = require('discord.js');
const { Intents } = Discord;
const intents = new Intents();

for (const intent of Object.keys(Intents.FLAGS)) {
    intents.add(intent);
}

const client = new Discord.Client({
    intents: ["GUILDS", "GUILD_MESSAGES", "GUILD_MEMBERS", "GUILD_BANS", "GUILD_MESSAGE_REACTIONS", "GUILD_PRESENCES"],
    partials: ["MESSAGE", "REACTION", "USER"]
});

const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
require('dotenv').config({ path: path.join(resourcePath, './.env') });

client.on('ready', () => {
    console.log(`^HVC Auction Bot Is Online^7`)
    init()
});

client.commands = new Discord.Collection();
client.auction = new Discord.Collection()

const init = async () => {
    fs.readdir(resourcePath + '/commands/', (err, files) => {
        if (err) console.error(err);
        files.forEach(f => {
            let command = require(`${resourcePath}/commands/${f}`);
            client.commands.set(command.conf.name, command);
        });
    });
}

client.on('messageCreate', (message) => {
    const auction = client.auction.get(message.channel.id)
    if(auction){
        if(message.author.bot) return;
        message.delete()
        if(!message.content.startsWith('.bid')) return;
    }
    const prefix = '.';
    if (message.author.bot) return;
    if (!message.content.startsWith(prefix) || message.author.bot) return;
    let command = message.content.split(' ')[0].slice(prefix.length);
    let params = message.content.split(' ').slice(1);
    let cmd;
    if (client.commands.has(command)) {
        cmd = client.commands.get(command);
    }
    if (cmd) {
        try {
            cmd.runcmd(exports, client, message, params);
        } catch (err) {
            console.log(err)
            init()
        }
    }
});

client.login(process.env.TOKEN);