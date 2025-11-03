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