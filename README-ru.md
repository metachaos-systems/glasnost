# Запуск Glasnost с помощью Docker

```
docker run -it -p 80:80 -e "GLASNOST_DB=..." -e "GLASNOST_DB_HOST=..." -e "GLASNOST_DB_USERNAME=..." -e "GLASNOST_DB_PASSWORD=..." -e "GLASNOST_DB_PORT=..." --restart on-failure:10 ontofractal/glasnost:latest
```

# Функционал

* Одновременно работает с блокчейнами Голоса и Steem
* Экстрактор для базы данных Postgres, который синхронизирует новые посты и комментариии в реальном времени, а также за последние 7 дней
* Добавлен API GraphQL endpoint в `/graphql` с объектами `comments` и `comment` (см. примеры)
* Добавлен интерактивный браузерный GraphiQL клиент в `/graphiql`

# Конфигурация

Для работы Glasnost необходима база PostgreSQL.

Вам необходимо настроить следующие параметры базы данных Postgres с помощью переменных Docker ENV:

* GLASNOST_DB
* GLASNOST_DB_HOST
* GLASNOST_DB_PORT
* GLASNOST_DB_USERNAME
* GLASNOST_DB_PASSWORD

Другие параметры, такие как PORT, STEEM_URL и GOLOS_URL, могут быть настроены в файле Docker.

# Примеры GraphQL запросов

```
{
  comments(blockchain:"golos", author: "ontofractal", isPost: true, category: "ru--kriptovalyuty", orderBy: TOTAL_PAYOUT_VALUE, sort: DESC){
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
  comment(blockchain:"golos", author: "ontofractal", permlink: "anons-novogo-etapa-akademii-i-obsuzhdenie-novykh-pravil"){
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
  block(blockchain:"golos", get_last: true){
    height,
    timestamp,
    transactions,
    witness
  }
}
```

```
{
  statistics(blockchain:"golos"){
    postCount,
    commentCount,
    authorCount
  }
}
```
