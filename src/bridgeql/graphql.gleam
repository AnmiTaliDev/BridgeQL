import gleam/json

pub fn wrap(field: String, body: String) -> String {
  let key = json.to_string(json.string(field))
  "{\"data\":{" <> key <> ":" <> body <> "}}"
}
