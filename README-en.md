# Deployment and configuration

Deployment is simple if you use Docker:

```
docker run -it -p 80:80 -e "GLASNOST_CONFIG_URL=..."  --restart on-failure:10 ontofractal/glasnost:latest
```

You can also use a service like [hyper.sh](https://hyper.sh/) for managed Docker container hosting.

# Example configuration JSON file

```
{
  "authors": [{
    "account_name": "ontofractal",
    "tags": {
      "blacklist": [],
      "whitelist": []
    }
  }, {
    "account_name": "...",
    "tags": {
      "blacklist": [],
      "whitelist": []
    }
  }
],
  "about_blog_permlink": "ann-introducing-glasnost-alpha-open-source-blog-and-app-server-for-steem-golos-blockchains",
  "about_blog_author": "ontofractal",
  "source_blockchain": "steem"
}

```

* `"source_blockchain"`: `steem` or `golos`
* `"about_blog_author"`:  post author steem or golos
* `"about_blog_permlink"`: post permlink on steem or golos

Other settings like `PORT`, `STEEM_URL` and `GOLOS_URL` can be configured in the Dockerfile.

# Tag filtering

Whitelisting rules are applied first: only posts with whitelisted tags are downloaded from the blockchain.
If `tags_whitelist` value is an empty list `[]` Whitelisting rules do *NOT* apply.

Blacklisting rules are applied afterwards: all posts with blacklisted tags are removed.



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
