import gleam/io
import gleam/list

pub fn main() -> Nil {
  io.println("Hello from my_project!")
  list.each(["Luch", "YOW"], greet)
}

pub fn greet(name: String) -> Nil {
  io.println("Hello, " <> name <> "!")
}
