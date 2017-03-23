# Deployment and configuration

Deployment is simple if you use Docker:

```
docker run -it -p 80:80 -e "GLASNOST_CONFIG_URL=..."  --restart on-failure:10 ontofractal/glasnost:latest
```

You can also use a service like [hyper.sh](https://hyper.sh/) for managed Docker container hosting.

Docker container configuration settings are:

* `"source_blockchain"`: `steem` or `golos`
* `"blog_author"`: account name on steem or golos
* `"about_blog_permlink"`: permlink of any post by blog author

# Tag filtering

Whitelisting rules are applied first: only posts with whitelisted tags are downloaded from the blockchain.
If `tags_whitelist` value is an empty list `[]` Whitelisting rules do *NOT* apply.

Blacklisting rules are applied afterwards: all posts with blacklisted tags are removed.


# Example configuration JSON file

```
{
  "blog_author": "ontofractal",
  "source_blockchain": "steem",
  "about_blog_permlink": "ann-introducing-glasnost-alpha-open-source-blog-and-app-server-for-steem-golos-blockchains",
  "tags_whitelist": [],
  "tags_blacklist": [
    "statistics",
    "stats"
  ]
}

```

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
