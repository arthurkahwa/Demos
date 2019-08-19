const pgPool = require('pg').Pool;
const config = require('./config/config');
const staticContenst = require('./config/teams_and_drivers');

const pgDatabase = new pgPool({
    user: config.db.user,
    password: config.db.password,
    database: config.db.database,
    host: config.db.host,
    port: config.db.port
});

// use an external function since we need to run nested queries on the database.
const execute = (query) => {
    return new Promise((resolve, reject) => {
        pgDatabase.query(query, (error, rows) => {
            if (error) {
                reject(error)
            }

            resolve(rows);
        });
    });
};

const getAllTeams = async (request, response) => {

    const results = {};
    const listOfTeams = [];

    results['info'] = 'F1 Season 2019 Team Info';

    let teamQuery = 'select * from team';
    const teams = await execute(teamQuery);
    for (const row in teams.rows) {
        let driverQuery = `select id, name from driver where fkteam = ${teams.rows[row].id}`;
        const drivers = await execute(driverQuery);

        teams.rows[row]['drivers'] = drivers.rows;
        listOfTeams.push(teams.rows[row]);
    }

    results['teams'] = listOfTeams;
    response.status(200).json(results);
};

const getStaticContent = (request, response) => {
    response.status(200).json(staticContenst);
};

module.exports = {
    getAllTeams,
    getStaticContent
};
