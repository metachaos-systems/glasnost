```
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export GOLOS_URL=wss://ws.golos.io
export STEEM_URL=wss://steemd.steemit.com
export MIX_ENV=prod
export PORT=80
export GLASNOST_SOURCE_BLOCKCHAIN=MY_SOURCE
export GLASNOST_BLOG_AUTHOR=MY_BLOG

git clone --depth=1 https://github.com/cyberpunk-ventures/glasnost /MY_GLASNOST_APP

cd /MY_GLASNOST_APP
mix local.hex --force
mix local.rebar --force
mix deps.get

cd /MY_GLASNOST_APP/assets
npm install
node node_modules/brunch/bin/brunch build

mkdir -p /MY_GLASNOST_APP/priv/data/mnesia
cd /MY_GLASNOST_APP
mix compile
mix ecto.create
mix ecto.migrate
mix phx.digest
mix phx.server
```
