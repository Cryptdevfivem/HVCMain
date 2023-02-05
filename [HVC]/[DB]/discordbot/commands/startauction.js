const ms = require('ms')
exports.runcmd = (fivemexports, client, message, args) => {
    const time = args[0];
    const spawncode = args[1];
    const speed = args[2]
    const image = args[3]
    const item = args.slice(4).join(' ')
    if (!message.member.roles.cache.some(r=>["850074619234222091"].includes(r.id))) {
        const newEmbed = new Discord.MessageEmbed()
            .setColor('#ffd700')
            .setDescription("You do not have permission to use this command")
        return message.channel.send({ embeds: [newEmbed] });
    }

    if (!time) {
        const newEmbed = new Discord.MessageEmbed()
            .setDescription("**Template:** `!startauction <Time> <Spawncode> <Top Speed> <Image Link> <Car Name>`")
            .setColor("#FF1023")
        return message.channel.send({ embeds: [newEmbed] })
    }
    if (!spawncode) {
        const newEmbed = new Discord.MessageEmbed()
        .setDescription("**Template:** `!startauction <Time> <Spawncode> <Top Speed> <Image Link> <Car Name>`")
            .setColor("#FF1023")
        return message.channel.send({ embeds: [newEmbed] })
    }
    if (!item) {
        const newEmbed = new Discord.MessageEmbed()
        .setDescription("**Template:** `!startauction <Time> <Spawncode> <Top Speed> <Image Link> <Car Name>`")
            .setColor("#FF1023")
        return message.channel.send({ embeds: [newEmbed] })
    }

    fivemexports.ghmattimysql.execute("SELECT * FROM hvc_user_vehicles WHERE vehicle = ?", [spawncode.toLowerCase()], (result) => {
        if (result) {
            message.guild.channels.create(item).then(channel => {
                client.auction.set(channel.id, {
                    item: item
                })
                channel.setParent('959937958406946857')
                const newEmbed = new Discord.MessageEmbed()
                    .setTitle(item)
                    .setDescription(`**Car Count:** ${result.length}\n**Top Speed:** ${speed}MPH`)
                    .setImage(`${image}`)
                    .setColor("#FF1023")
                    .setFooter(`Auction will end in ${time}, use ".bid (amount)" to bid!`)
                channel.send({ embeds: [newEmbed] })

                setTimeout(function () {
                    const auction = client.auction.get(channel.id)
                    if (!auction.winner || !auction.amount) {
                        const newEmbed = new Discord.MessageEmbed()
                            .setColor("#FF1023")
                            .setTitle("Auction Ended")
                            .setDescription("No one bidded")
                        return channel.send({ embeds: [newEmbed] })
                    }
                    client.auction.set(channel.id, null)
                    const formatter = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'GBP', maximumFractionDigits: 0 })
                    let formattedbid = formatter.format(auction.amount);
                    fivemexports.ghmattimysql.execute("SELECT * FROM `hvc_user_ids` WHERE identifier = ?", ["discord:" + auction.winner], (result) => {
                        permID = `${result[0].user_id}`
                        const newEmbed = new Discord.MessageEmbed()
                            .setTitle("Auction Ended")
                            .setDescription(`<@${auction.winner}> has won the auction for **${formattedbid}**`)
                            .setFooter(`Perm ID: ${permID}`)
                            .setColor("#FF1023")
                        channel.send({ embeds: [newEmbed] })
                        const DMEmbed = new Discord.MessageEmbed()
                            .setTitle("Auction Ended")
                            .setDescription(`You have won the **${item}** auction, make sure you have the amount you bidded or you may be liable for a 1 week ban`)
                            .setColor("#FF1023")
                        message.author.send({ embeds: [DMEmbed] })
                        channel.permissionOverwrites.edit(message.guild.id, { SEND_MESSAGES: false });
                    })


                }, ms(time))
            })
        }
    })

}

exports.conf = {
    name: "startauction"
}