FROM elixir:1.9.0

RUN apt-get update && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install hex phx_new 1.4.9 --force && \
    apt-get install -y inotify-tools

EXPOSE 4000
