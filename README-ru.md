# Запуск Glasnost с помощью Docker

```
docker run -it -p 80:80 -e "GLASNOST_CONFIG_URL=..."  --restart on-failure:10 ontofractal/glasnost:latest
```

## Настройки

Для выбора блокчейна и страницы "о блоге" используются следующие свойства JSON конфига.

* `"source_blockchain"`: `steem` или `golos`
* `"about_blog_author"`: имя аккаунта в `steem` или `golos`, который опубликовал пост с описанием блога
* `"about_blog_permlink"`: permlink (не полный урл) поста с описанием блога

Такие переменные пространства, как `PORT`, `STEEM_URL` и `GOLOS_URL` могут быть изменены в Dockerfile для создания нового докер имиджа.

# Пример конфига

```
{
  "authors": [{
    "account_name": "ontofractal",
    "tags": {
      "blacklist": ["ru--statistika"],
      "whitelist": []
    }
  }, {
    "account_name": "glasnost",
    "tags": {
      "blacklist": [],
      "whitelist": []
    }
  }
],
  "about_blog_permlink": "anons-open-sors-platformy-dlya-razrabotki-prilozhenii-na-blokcheine-golos-fidbek-privetstvuetsya",
  "about_blog_author": "ontofractal",
  "source_blockchain": "golos"
}
```

# Остановка докер контейнера Glasnost

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
