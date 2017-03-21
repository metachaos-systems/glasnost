# Deployment and configuration

Deployment is simple if you use Docker:

```
docker run -it -p 80:80 -e "GLASNOST_CONFIG_URL=..."  --restart on-failure:10 ontofractal/glasnost:latest
```

You can also a service like [hyper.sh](https://hyper.sh/) for managed Docker container hosting.

Docker container configuration settings are:

* `"source_blockchain"`: `steem` or `golos`
* `"blog_author"`: account name on steem or golos
* `"about_blog_permlink"`: permlink of any post by blog author

Other settings like `PORT`, `STEEM_URL` and `GOLOS_URL` can be configured in the Dockerfile.

# Stopping and removing the Glasnost container

```
docker ps
```
find a container name `CONTAINER_NAME` (in the `NAMES` column)

```
docker stop CONTAINER_NAME
```
```
docker rm CONTAINER_NAME
```
