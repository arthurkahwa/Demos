const pgPool = require('pg').Pool;

const pgDatabase = new pgPool({
    user: 'arthur',
    password: '321!Ende',
    database: 'f1season2019',
    host: 'localhost',
    port: 5432
});

const execute = (query) => {
    return new Promise((resolve, reject) => {
        pgDatabase.query(query,
            (error, rows) => {
                if (error) {
                    reject(error)
                }

                resolve(rows);
            });
    });
}

const getAllTeams = async (request, response) => {

    const results = {};
    const listOfTeams = [];

    results['info'] = 'F1 Season 2019 API';

    const teamQuery = 'select * from team';
    const teams = await execute(teamQuery);
    for (const row in teams.rows) {
        const driverQuery = 'select name from driver where fkteam = ' + teams.rows[row].id;
        const drivers = await execute(driverQuery);

        teams.rows[row]['drivers'] = drivers.rows;
        listOfTeams.push(teams.rows[row]);
    }

    results['teams'] = listOfTeams;
    response.status(200).json(results);
};

module.exports = {
    getAllTeams
};
