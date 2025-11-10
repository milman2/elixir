# docker postgresql
```shell
docker pull postgres
docker run --name my-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=elixir_gist_dev -p 5432:5432 -d postgres
```

# setting up 
```shell
mix phx.new elixir_gist --no-install --binary-id
cd elixir_gist
```