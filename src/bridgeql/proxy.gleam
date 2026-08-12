import gleam/http/request
import gleam/httpc
import gleam/result

pub fn fetch(url: String) -> Result(String, String) {
  use req <- result.try(
    request.to(url)
    |> result.replace_error("invalid backend url: " <> url),
  )

  use resp <- result.try(
    httpc.send(req)
    |> result.map_error(describe_error),
  )

  Ok(resp.body)
}

fn describe_error(error: httpc.HttpError) -> String {
  case error {
    httpc.InvalidUtf8Response -> "backend response was not valid utf-8"
    httpc.ResponseTimeout -> "backend request timed out"
    httpc.FailedToConnect(..) -> "failed to connect to backend"
  }
}
