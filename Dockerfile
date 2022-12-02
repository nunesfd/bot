FROM elixir:1.13.3-alpine

RUN mix local.hex --force && mix local.rebar --force
COPY . .
# instalar as dependencias
RUN mix do deps.get, deps.compile

# executar o servidor
CMD ["mix", "phx.server"]