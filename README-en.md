# Launching Glasnost with Docker

```
docker run -it -p 80:80 -e "GLASNOST_DB=..." -e "GLASNOST_DB_HOST=..." -e "GLASNOST_DB_USERNAME=..." -e "GLASNOST_DB_PASSWORD=..." -e "GLASNOST_DB_PORT=..." --restart on-failure:10 ontofractal/glasnost:latest
```

# Features

* Extractor for Postgres database that will sync comments in realtime and look back 7 days in the past  
* GraphQL API endpoint at `/graphql`
* Interactive GraphiQL endpoint at `/graphiql`

# Configuration

Glasnost now requires PostgresSQL.

You need to setup the following Postgres database settings using Docker ENV variables:

* GLASNOST_DB
* GLASNOST_DB_HOST
* GLASNOST_DB_PORT
* GLASNOST_DB_USERNAME
* GLASNOST_DB_PASSWORD

Other settings like PORT, STEEM_URL and GOLOS_URL can be configured in the Dockerfile.
