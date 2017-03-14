# Deployment and configuration

Deployment is simple if you use Docker:

```
docker run -it -e "GLASNOST_SOURCE_BLOCKCHAIN=..." -e "GLASNOST_BLOG_AUTHOR=..." --restart always ontofractal/glasnost:0.1
```

Configuration settings are:

* `GLASNOST_SOURCE_BLOCKCHAIN`: `steem` or `golos`
* "GLASNOST_BLOG_AUTHOR": your steem/golos account name

Other settings like PORT, STEEM_URL and GOLOS_URL can be configured in the Dockerfile.
