# Запуск Glasnost с помощью Docker

```
docker run -it -p 80:80 -e "GLASNOST_CONFIG_URL=..."  --restart on-failure:10 ontofractal/glasnost:latest
```

## Настройки

Для выбора блокчейна и страницы "о блоге" используются следующие свойства JSON конфига.

* `"source_blockchain"`: `steem` или `golos`
* `"about_blog_author"`: имя аккаунта в `steem` или `golos`, который опубликовал пост с описанием блога
* `"about_blog_permlink"`: permlink (не полный урл) поста с описанием блога

Как правило конфигурация приложений на Elixir происходит на этапе компиляции. Это означает, что
для изменений такие переменных пространства, как `PORT`, `STEEM_URL` и `GOLOS_URL` необходимо внести новые значения в Dockerfile и создать новый имидж с обновленными переменными среды.

# Пример конфига

```
{
  "authors": [{
    "account_name": "ontofractal",
    "filters": {
      "tags": {
        "blacklist": ["ru--statistika"],
        "whitelist": []
      },
      "title": {
        "blacklist": [],
        "whitelist": ["Урок \\d"]
      },
      "created": {
        "only_after": "2017-01-01",
        "only_before": ""
      }
    }
  }, {
    "account_name": "glasnost",
    "filters": {
      "tags": {
        "blacklist": [],
        "whitelist": []
      },
      "title": {
        "blacklist": [],
        "whitelist": []
      },
      "created": {
        "only_after": "2017-01-01",
        "only_before": ""
      }
    }
  }],
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
