# Glasnost

Glasnost is a generic app and blog server for Golos and Steem blockchains.

# Deployment and configuration

# Деплоймент и запуск

В следующих версиях Glasnost будет упакована в удобный для использования докер имидж.

На сервере должен быть установлен Erlang/OTP и Elixir.

```
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export GOLOS_URL=wss://ws.golos.io
export STEEM_URL=wss://steemd.steemit.com/
export MIX_ENV=prod
export PORT=80
export GLASNOST_BLOG_ACCOUNT=ontofractal

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
apt-get install -y nodejs

git clone --depth=1 https://github.com/cyberpunk-ventures/glasnost /YOUR_GLASNOST_APP

cd /YOUR_GLASNOST_APP
mix local.hex --force
mix local.rebar --force
mix deps.get

cd /YOUR_GLASNOST_APP/assets
npm install
node node_modules/brunch/bin/brunch build

mkdir -p /YOUR_GLASNOST_APP/priv/data/mnesia
cd /YOUR_GLASNOST_APP
mix compile
mix ecto.create
mix ecto.migrate
mix phx.digest
mix phx.server
```

Glasnost -- опен сорс сервер для приложений для платформы GOLOS. Использует Elixir, Phoenix и Mnesia.
