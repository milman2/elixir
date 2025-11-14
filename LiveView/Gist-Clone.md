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

# Setting up and User Authentication
```shell
mix phx.new elixir_gist --no-install --binary-id
cd elixir_gist

mix deps.get
mix phx.gen.auth Accounts User users 
mix deps.get
mix ecto.setup
mix phx.server # http://localhost:4000, http://192.168.50.135:4000
```

# Generating Our Schemas
- user_id가 2개가 생성되는 현상 -> 명령 수정이 필요한가?
```shell
mix phx.gen.context Gists Gist gists user_id:references:users name:string description:text markup_text:text 
mix phx.gen.context Gists SavedGist saved_gists user_id:references:users gist_id:references:gists 
mix phx.gen.context Comments Comment comments user_id:references:users gist_id:references:gists markup_text:text

mix ecto.migrate
```

# 
```shell
npm install highlight.js --prefix assets
```