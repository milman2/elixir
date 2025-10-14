# install Elixir
- elixir-lang.org

```shell
curl -fsSO https://elixir-lang.org/install.sh
sh install.sh elixir@1.18.4 otp@27.3.4

# ~/.bashrc
export PATH=$HOME/.elixir-install/installs/otp/27.3.4/bin:$PATH
export PATH=$HOME/.elixir-install/installs/elixir/1.18.4-otp-27/bin:$PATH

iex
```

```shell
erl -s erlang halt
```