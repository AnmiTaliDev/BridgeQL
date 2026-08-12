import bridgeql/config
import bridgeql/graphql
import bridgeql/proxy
import gleam/dynamic/decode
import gleam/http
import gleam/string
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, config: config.Config) -> Response {
  case wisp.path_segments(req) {
    ["graphql"] -> handle_graphql(req, config)
    _ -> wisp.not_found()
  }
}

fn handle_graphql(req: Request, config: config.Config) -> Response {
  use <- wisp.require_method(req, http.Post)
  use body <- wisp.require_json(req)

  let decoder = {
    use query <- decode.field("query", decode.string)
    decode.success(query)
  }

  case decode.run(body, decoder) {
    Error(_) -> wisp.bad_request("request body must contain a \"query\" string")
    Ok(query) ->
      case parse_field(query) {
        Error(_) ->
          wisp.bad_request("query must be a single field, e.g. \"{ users }\"")
        Ok(field) -> resolve(field, config)
      }
  }
}

fn resolve(field: String, config: config.Config) -> Response {
  let url = config.backend_url <> "/" <> field
  case proxy.fetch(url) {
    Ok(response_body) ->
      wisp.json_response(graphql.wrap(field, response_body), 200)
    Error(reason) -> {
      wisp.log_error(reason)
      wisp.internal_server_error()
    }
  }
}

fn parse_field(query: String) -> Result(String, Nil) {
  let trimmed = string.trim(query)
  case string.starts_with(trimmed, "{"), string.ends_with(trimmed, "}") {
    True, True -> {
      let inner =
        trimmed
        |> string.drop_start(1)
        |> string.drop_end(1)
        |> string.trim
      case inner {
        "" -> Error(Nil)
        _ -> Ok(inner)
      }
    }
    _, _ -> Error(Nil)
  }
}
