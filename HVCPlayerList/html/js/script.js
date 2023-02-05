const doc = document;
var shaz = false 
window.addEventListener('load', () => {
    this.addEventListener('message', e => {
        if (e.data.action == 'openScoreboard') {
            doc.getElementById('wrapper').style.display = 'flex';
        }
        if (e.data.action == 'updatePlayers') {
            updateScoreboard(e.data.players, e.data.maxPlayers, e.data.runTime, e.data.jobs);
        }
        if (e.data.action == 'destroy') {
            doc.getElementById('wrapper').style.display = 'none';
        }
    })
})


const updateScoreboard = (players, maxPlayers, runTime, currJobs) => {
    const UserIDs = doc.getElementById('cont-UserIDs');
    const names = doc.getElementById('cont-names');
    const times = doc.getElementById('cont-time');
    const status = doc.getElementById('cont-status');

    for (let i=doc.getElementsByClassName('currentData').length - 1; i >= 0; i--) {
        doc.getElementsByClassName('currentData')[i].remove()
    }

    players.forEach(player => {
        if (!doc.getElementById(player.playersName)) {
            const UserID = doc.createElement('span');
            const name = doc.createElement('span');
            const time = doc.createElement('span');
            const job = doc.createElement('span');

            UserID.textContent = player.UserID;
            time.textContent = player.playersTime;
            name.textContent = player.playersName;
            job.textContent = player.playersJob;

            name.id = player.playersName;
            UserID.classList.add('currentData', players.indexOf(player));
            time.classList.add('currentData', players.indexOf(player));
            name.classList.add('currentData',players.indexOf(player));
            job.classList.add('currentData', players.indexOf(player));

            names.appendChild(name);
            UserIDs.appendChild(UserID)
            times.appendChild(time);
            status.appendChild(job);
        }
    });

    doc.getElementById('players').textContent = maxPlayers;
    doc.getElementById('runtime').textContent = runTime;
    doc.getElementById('curr-admin').textContent = currJobs.admin;
    doc.getElementById('curr-police').textContent = currJobs.police;
    doc.getElementById('curr-nhs').textContent = currJobs.nhs;
    doc.getElementById('curr-civilian').textContent = currJobs.civilian;
}


document.onkeyup = function (data) {
    if (data.which == 36 && shaz) {
        $.post('https://HVCPlayerList/exit', JSON.stringify({}));
        shaz = false 
    }
};

document.onkeydown = function (data) {
    if (data.which == 36 && !shaz) {
        shaz = true 
    }
}