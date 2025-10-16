# Phoenix
- Functional Web Framework for Elixir
- MVC architecture
- Real-time features with Channels
- LiveView for reactive programming

## 설치

```shell
# install hex package manager
mix local.hex

# Phoenix 프로젝트 생성기 설치
mix archive.install hex phx_new

# 버전 확인
mix phx.new --version
```

## 프로젝트 생성

```shell
# 새 Phoenix 프로젝트 생성
mix phx.new my_app

# 데이터베이스 없이 생성
mix phx.new my_app --no-ecto

# API 전용 프로젝트
mix phx.new my_app --no-html --no-assets
```

## 프로젝트 실행 (demo)
```shell
cd demo
mix phx.server

# run you app inside IEx (Interactive Elixir)
iex -S mix phx.server
```

## IP 바인딩 설정
- config/dev.exs
```yaml
config :your_app, YourAppWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  ...
```

## Huff

# REST API : forum
```shell
mix phx.new forum --database sqlite3
mix ecto.create
mix phx.server

sudo apt update
sudo apt install -y inotify-tools

# IP 바인딩 설정할 것!!
# 192.168.50.135:4000

mix phx.gen.json Posts Post posts body:string title:string
```