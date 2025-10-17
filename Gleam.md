# Gleam
- 정적 타입을 지원하는 함수형 언어
- Erlang의 BEAM VM 위에서 실행
- 동시성
- 안정성
- 컴파일 타임 타입 검사

# install
```shell
sudo apt install erlang
curl -L https://github.com/gleam-lang/gleam/releases/download/v1.12.0/gleam-v1.12.0-x86_64-unknown-linux-musl.tar.gz | tar -xz && mv gleam ~/.local/bin/ && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

# Sample
```shell
cd /home/milman2/elixir/Gleam && export PATH="$HOME/.local/bin:$PATH" && gleam new my_project
cd /home/milman2/elixir/Gleam/my_project && export PATH="$HOME/.local/bin:$PATH" && gleam test

gleam run
gleam test

curl -L https://github.com/watchexec/watchexec/releases/download/v2.3.2/watchexec-2.3.2-x86_64-unknown-linux-musl.tar.xz | tar -xJ
mv watchexec-2.3.2-x86_64-unknown-linux-musl/watchexec ~/.local/bin/ && rm -rf watchexec-2.3.2-x86_64-unknown-linux-musl
export PATH="$HOME/.local/bin:$PATH" &&  watchexec --wrap-process=session --restart -iet "clear && gleam test"
```

# VS Code
```shell
code --install-extension gleam-lang.gleam-vscode

gleam lsp --help
```


# package manager
```shell
gleam add wisp@1 mist@3
```

# Wisp
- Web Server Framework
    - backend server

# Mist
- Client-side Web Framework
- Elm style architecture(TEA?) : Model -> Update -> View

# Lustre
- UI Component Library
- cf. React JSX

# Squirrel 
- SQL


# pokedex example
- Gleam + Lustre
```shell
gleam new pokedex
cd pokedex

gleam add lustre
gleam add --dev lustre_dev_tools

sudo apt install inotify-tools

curl -fsSL https://s3.amazonaws.com/rebar3/rebar3 -o rebar3 && chmod +x rebar3 && mv rebar3 ~/.local/bin/
export PATH="$HOME/.local/bin:$PATH" && rebar3 --version
```
```shell
gleam run -m lustre/dev start --host=0.0.0.0 --port=1234
gleam run -m lustre/dev add tailwind

# netstat -tlnp | grep :1234

curl -s http://localhost:1234 | head -10
```
