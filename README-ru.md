# Простой запуск Glasnost с помощью Docker

```
docker run -it -p 80:80 -e "GLASNOST_CONFIG_URL=..."  --restart on-failure:10 ontofractal/glasnost:latest
```

## Настройки

Для выбора блокчейна и блога используются свойства JSON конфига.

* `"source_blockchain"`: `steem` или `golos`
* `"blog_author"`: имя аккаунта в `steem` или `golos`
* `"about_blog_permlink"`: permlink (не полный урл) поста с описанием блога

Такие переменные пространства, как `PORT`, `STEEM_URL` и `GOLOS_URL` могут быть изменены в Dockerfile для создания нового докер имиджа.

# Остановка Glasnost с помощью Docker

```
docker ps
```

и найти имя контейнера `CONTAINER_NAME` (в колонке `NAMES`)

```
docker stop CONTAINER_NAME
```
```
docker rm CONTAINER_NAME
```
