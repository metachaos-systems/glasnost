# Запуск Glasnost с помощью Docker

```
docker run -it -p 80:80 -e "GLASNOST_DB=..." -e "GLASNOST_DB_HOST=..." -e "GLASNOST_DB_USERNAME=..." -e "GLASNOST_DB_PASSWORD=..." -e "GLASNOST_DB_PORT=..." --restart on-failure:10 ontofractal/glasnost:latest
```

# Функционал

* Одновременно работает с блокчейнами Голоса и Steem
* Экстрактор для базы данных Postgres, которая будет синхронизировать посты и комментариии в реальном времени и оглядываться назад в течение 7 дней
* Endpoint API GraphQL в `/graphql`
* Интерактивный браузерный GraphiQL клиент в `/graphiql`

# Конфигурация

Glasnost теперь требует PostgresSQL.

Вам необходимо настроить следующие параметры базы данных Postgres с помощью переменных Docker ENV:

* GLASNOST_DB
* GLASNOST_DB_HOST
* GLASNOST_DB_PORT
* GLASNOST_DB_USERNAME
* GLASNOST_DB_PASSWORD

Другие параметры, такие как PORT, STEEM_URL и GOLOS_URL, могут быть настроены в файле Docker.

# Примеры GraphQL запроса

```
{
  comments(blockchain:"golos", author: "ontofractal"){
    id,
    title,
    author,
    permlink,
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
    created,
    totalPayoutValue,
    pendingPayoutValue
  }
}
```
