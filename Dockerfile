FROM elixir:latest

ENV DEBIAN_FRONTEND=noninteractive

ADD . /glasnost_app
WORKDIR /glasnost_app

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --all

ENV MIX_ENV prod
ENV PORT 80

RUN mix compile
RUN mix release
RUN rm -rf deps lib config

ENTRYPOINT _build/prod/rel/glasnost/releases/0.1.0/glasnost.sh foreground
