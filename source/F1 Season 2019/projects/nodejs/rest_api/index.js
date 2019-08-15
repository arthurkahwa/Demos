const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const port = 3000;
const pgdb = require('./queries');

app.use(bodyParser.json());

app.use(
    bodyParser.urlencoded({
        extended: true,
    })
);

app.get('/f1/teams', pgdb.getAllTeams);

app.listen(port, () => {
    console.log(`API is listening on port ${port}!`)
});
