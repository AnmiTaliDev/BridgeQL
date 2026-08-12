import bridgeql/config
import bridgeql/router
import gleam/erlang/process
import gleam/int
import gleam/io
import mist
import wisp
import wisp/wisp_mist

pub fn main() -> Nil {
  case config.load() {
    Ok(config) -> start(config)
    Error(reason) -> io.println_error(reason)
  }
}

fn start(config: config.Config) -> Nil {
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)

  let assert Ok(_) =
    router.handle_request(_, config)
    |> wisp_mist.handler(secret_key_base)
    |> mist.new
    |> mist.port(config.port)
    |> mist.start

  io.println(
    "bridgeql listening on port "
    <> int.to_string(config.port)
    <> ", proxying to "
    <> config.backend_url,
  )

  process.sleep_forever()
}
