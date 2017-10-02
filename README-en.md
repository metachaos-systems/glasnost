# Launching Glasnost with Docker

```
docker run -it -p 80:80 -e "GLASNOST_DB=..." -e "GLASNOST_DB_HOST=..." -e "GLASNOST_DB_USERNAME=..." -e "GLASNOST_DB_PASSWORD=..." -e "GLASNOST_DB_PORT=..." --restart on-failure:10 ontofractal/glasnost:latest
```

# Features

* Works both with Steem and Golos blockchains
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

#  GraphQL queries examples

```
{
  comments(blockchain:"steem", author: "ontofractal", isPost: true, category: "steemdev", orderBy: TOTAL_PAYOUT_VALUE, sort: DESC){
    id,
    title,
    author,
    permlink,
    parentAuthor,
    parentPermlink,
    body
    tags,
    category,
    created,
    totalPayoutValue,
    pendingPayoutValue
  }
}
```


```
{
  comment(blockchain:"steem", author: "ontofractal", permlink: "glasnost-v0-12-released-now-with-postgresql-realtime-and-7-day-lookback-comments-data-sync-open-source-app-server-for-steem"){
    id,
    title,
    author,
    permlink,
    parentAuthor,
    parentPermlink,
    body
    tags,
    category,
    created,
    totalPayoutValue,
    pendingPayoutValue
  }
}
```


```
{
  block(blockchain:"steem", getLast: true){
    height,
    timestamp,
    transactions,
    witness
  }
}
```

```
{
  statistics(blockchain:"steem"){
    postCount,
    commentCount,
    authorCount
  }
}
```
