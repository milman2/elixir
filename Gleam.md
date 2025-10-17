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
```

# VS Code
```shell
code --install-extension gleam-lang.gleam-vscode

gleam lsp --help
```