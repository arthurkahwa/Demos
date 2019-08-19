## F1 Season 2019
Full stack implementation of the 2019 Formula 1 Season

### Database schema and data
- These are from a PostgreSQL Database
- Located in the *sql* folder

### Web Service
- Located in the _nodejs/rest_api_ folder
- Start the service with **node index.js**
- The service listens on port 3000.
  This can be changed in index.js
-  The following endpoints are implemented:
    - _'/f1/teams'_ - Live reading from the database
    - _'/f1/static'_ - Data from a static json file
