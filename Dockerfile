FROM elixir:slim

ENV DEBIAN_FRONTEND=noninteractive

ENV GOLOS_URL=wss://ws.golos.io
ENV STEEM_URL=wss://steemd.steemit.com

RUN apt update
RUN apt install -y curl
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt install -y nodejs

ADD . /glasnost_app
WORKDIR /glasnost_app

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.update --all

ENV MIX_ENV prod
ENV PORT 80

WORKDIR /glasnost_app/assets
RUN npm install && \
 node node_modules/brunch/bin/brunch build && \
 rm -rf ./assets

WORKDIR /glasnost_app
RUN rm -r /glasnost_app/priv/data/mnesia
RUN mkdir -p /glasnost_app/priv/data/mnesia

RUN mix compile
RUN mix ecto.create
RUN mix ecto.migrate

RUN mix phx.digest


ENTRYPOINT mix phx.server
