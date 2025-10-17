import gleam/io
import gleam/list

// import gleam/string_tree
// import wisp.{type Request, type Response}

pub fn main() -> Nil {
  io.println("Hello from my_project!")
  list.each(["Luch", "YOW"], greet)
}

pub fn greet(name: String) -> Nil {
  io.println("Hello, " <> name <> "!")
}
// pub fn handle_request(_req: Request) -> Response {
//   todo
//   // {
//   //   status: 200,
//   //   headers: [("Content-Type", "text/plain")],
//   //   body: "Hello, World!"
//   // }

//   let html = "<h1>Hello, World</h1>"
//   let body = string_tree.from_string(html)
//   wisp.html_response(body, 200)
// }
