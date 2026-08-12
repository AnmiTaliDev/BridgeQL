import envoy
import gleam/int
import gleam/result

pub type Config {
  Config(backend_url: String, port: Int)
}

pub fn load() -> Result(Config, String) {
  use backend_url <- result.try(
    envoy.get("BACKEND_URL")
    |> result.replace_error("BACKEND_URL environment variable must be set"),
  )

  let port =
    envoy.get("PORT")
    |> result.try(int.parse)
    |> result.unwrap(8080)

  Ok(Config(backend_url: backend_url, port: port))
}
