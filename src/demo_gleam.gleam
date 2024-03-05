import mist
import gleam/erlang/process
import gleam/bytes_builder
import gleam/http/response.{Response}

pub fn main() {
  let assert Ok(_) =
    web_service
    |> mist.new
    |> mist.port(8080)
    |> mist.start_http
  process.sleep_forever()
}

fn web_service(_request) {
  let body = bytes_builder.from_string("Hello, Joe!")
  Response(200, [], mist.Bytes(body))
}
