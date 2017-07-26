# Запуск Glasnost с помощью Docker

```
docker run -it -p 80:80 -e "GLASNOST_DB=..." -e "GLASNOST_DB_HOST=..." -e "GLASNOST_DB_USERNAME=..." -e "GLASNOST_DB_PASSWORD=..." -e "GLASNOST_DB_PORT=..." --restart on-failure:10 ontofractal/glasnost:latest
```

# Обновление образа Docker перед установкой новой версии Glasnost

Если вы использовали более раннюю версию Glasnost, то перед запуском новой версии надо обновить Docker образ:
```
docker pull ontofractal/glasnost:latest
```


# Остановка докер контейнера Glasnost

`docker ps`

и найти имя контейнера `CONTAINER_NAME` (в колонке `NAMES`)

`docker stop CONTAINER_NAME`

`docker rm CONTAINER_NAME`
