# [Phoenix crash course](https://www.youtube.com/watch?v=hsYrr1OgQ28&list=PLbV6TI03ZWYXKCJePfD8G34hyWdW_WLFk&index=1)
## install
```shell
# 
mix local.hex

# Phoenix application generator
mix archive.install hex phx_new
```

## Up and Running
```shell
mix phx.new shop --database sqlite3
cd shop
mix ecto.create
mix phx.server
```

- /lib/shop/ # business domain (model)
- /lib/shop_web/ # controllers and views

```shell
mix phx.routes
```

# Ecto
```shell
mix phx.gen.schema Product products name slug:unique console:enum:pc:xbox:nintendo:playstation 
mix ecto.migrate
mix ecto.drop
```

```shell
iex -S mix phx.server

alias Shop.Repo
alias Shop.Product

product = %Product{name: "Overwahtch 2", slug: "overwatch-2", console: :pc}
Repo.all(Product)
Repo.insert(product)

changeset = Product.changeset(%Product{}, %{name: "Diablo 4", console: "xbox"})
Repo.insert(changeset)
```

# Mix Tasks
```shell
mix phx.gen.context Consoles Console consoles name:string price:integer
mix ecto.migrate # mix ecto.rollback

mix phx.gen.html Promotions Promotion promotions name:string code:string:unique expires_at:utc_datetime
mix ecto.migrate

mix phx.gen.json Promotions Promotion promotions name:string code:string:unique
mix ecto.migrate
mix phx.routes | grep promotion
```