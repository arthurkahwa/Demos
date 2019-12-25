const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const config = require('./config/config');
const port = config.api.port;
const queries = require('./queries');

app.use(bodyParser.json());

app.use(
    bodyParser.urlencoded({
        extended: true,
    })
);

app.use('/f1/images', express.static('images'))

app.get('/f1/teams', queries.getAllTeams);
app.get('/f1/static', queries.getStaticContent);

app.listen(port, () => {
    console.log(`API is listening on port ${port}!`)
});
