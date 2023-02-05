exports.runcmd = (fivemexports, client, message, args) => {
    const amount = args[0];
    if (isNaN(amount)) {
        message.delete()
        return
    }

    const auction = client.auction.get(message.channel.id)
    if (!auction) return;
    if (amount < 100000) {
        const newEmbed = new Discord.MessageEmbed()
            .setDescription("Starting bid is **£100,000**, please bid higher")
            .setColor("#FF1023")
        return message.author.send({ embeds: [newEmbed] })
    }
    if (!auction) {
        const newEmbed = new Discord.MessageEmbed()
            .setDescription("There is no auction in this channel")
            .setColor("#FF1023")
        return message.channel.send({ embeds: [newEmbed] })
    }

    let bank = undefined;
    let wallet = undefined;
    let totalMoney;
    fivemexports.ghmattimysql.execute("SELECT * FROM `hvc_user_ids` WHERE identifier = ?", ["discord:" + message.author.id], (result) => {
        permID = `${result[0].user_id}`

        let bank = undefined;
        let wallet = undefined;
        fivemexports.ghmattimysql.execute("SELECT * FROM hvc_user_moneys WHERE user_id = ?", [permID], (result) => {
            if (result) {
                bank = result[0].bank
                wallet = result[0].wallet
                totalMoney = parseInt(bank) + parseInt(wallet);

                if (amount > totalMoney) {
                    const formatter = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'GBP', maximumFractionDigits: 0 })
                    let formattedbid = formatter.format(amount);
                    const newEmbed = new Discord.MessageEmbed()
                        .setDescription(`You do not have **${formattedbid}**`)
                        .setColor("#FF1023")
                    return message.author.send({ embeds: [newEmbed] })
                }
                if (amount < auction.amount) {
                    const newEmbed = new Discord.MessageEmbed()
                        .setDescription("You must bid higher than the current bid")
                        .setColor("#FF1023")
                    return message.author.send({ embeds: [newEmbed] })
                }
                message.delete()
                const formatter = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'GBP', maximumFractionDigits: 0 })
                let formattedbid = formatter.format(amount);
                const newEmbed = new Discord.MessageEmbed()
                    .setAuthor(`${message.author.tag} has bidded ${formattedbid}`, message.author.displayAvatarURL({ dynamic: true }))
                    .setFooter(`Perm ID: ${permID}`)
                    .setTimestamp()
                    .setColor("#FF1023")
                message.channel.send({ embeds: [newEmbed] })
                client.auction.set(message.channel.id, {
                    item: auction.item,
                    amount: amount,
                    winner: message.author.id
                })
            } else {
                message.delete()
                const newEmbed = new Discord.MessageEmbed()
                    .setDescription("Error on bidding, please to DM <@921129197928349826> so he can fix it")
                    .setColor("#FF1023")
                return message.author.send({ embeds: [newEmbed] }).then((msg) => {
                    setTimeout(() => message.delete(), 5000);
                })
            }
        })
    });
}

exports.conf = {
    name: "bid"
}