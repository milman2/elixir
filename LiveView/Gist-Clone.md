# docker postgresql
```shell
docker pull postgres
docker run --name my-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=elixir_gist_dev -p 5432:5432 -d postgres
docker inspect my-postgres

docker exec -it my-postgres psql -U postgres -d elixir_gist_dev

sudo apt update
sudo apt install postgresql-client
psql -h localhost -p 5432 -U postgres -d elixir_gist_dev
```

# setting up 
```shell
mix phx.new elixir_gist --no-install --binary-id
cd elixir_gist
```