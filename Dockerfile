FROM elixir:latest

ENV DEBIAN_FRONTEND=noninteractive

ENV GOLOS_URL=wss://ws.golos.io
ENV STEEM_URL=wss://steemd.steemit.com

RUN apt update
RUN apt install -y curl
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt install -y nodejs


ADD . /glasnost_app
WORKDIR /glasnost_app

RUN chmod +x start.sh

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.update --all

ENV MIX_ENV prod
ENV PORT 80

RUN mix compile

RUN mix phx.digest

ENTRYPOINT ./start.sh
