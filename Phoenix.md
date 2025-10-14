# Phoenix
- Functional Web Framework for Elixir
- MVC architecture
- Real-time features with Channels
- LiveView for reactive programming

## 설치

```shell
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