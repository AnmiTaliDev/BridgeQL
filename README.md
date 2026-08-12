# BridgeQL

BridgeQL is a minimal REST-to-GraphQL proxy written in [Gleam](https://gleam.run). It accepts a very small GraphQL-style query, forwards it as a plain REST request to a configurable backend API, and wraps the backend's JSON response in a GraphQL-style `data` envelope.

This is a **learning project**. It exists to explore Gleam, `wisp`, `mist`, and the general shape of a REST-to-GraphQL bridge. It is **not** intended for production use: there is no authentication, no caching, no retry logic, no real GraphQL schema, and no test suite. See `ROADMAP.md` for a full list of what has been intentionally left out.

## How it works

BridgeQL exposes a single endpoint, `POST /graphql`. The request body must contain a `query` field holding a bare field name wrapped in braces, for example:

```json
{ "query": "{ users/1 }" }
```

The text between the braces is treated as a path segment and appended to the configured backend URL. BridgeQL performs a `GET` request to that URL, then wraps the raw JSON response body in a GraphQL-style envelope:

```json
{ "data": { "users/1": { "id": 1, "name": "Leanne Graham", "...": "..." } } }
```

There is no query language parsing beyond this convention: no arguments, no nested selections, no mutations, no schema. It resolves exactly one field per request against exactly one backend.

## Configuration

BridgeQL is configured entirely through environment variables:

| Variable      | Required | Default | Description                                  |
|---------------|----------|---------|-----------------------------------------------|
| `BACKEND_URL` | yes      | -       | Base URL of the REST backend to proxy to      |
| `PORT`        | no       | `8080`  | Port BridgeQL's HTTP server listens on        |

## Running

Requires the [Gleam toolchain](https://gleam.run/getting-started/installing/) and Erlang/OTP.

```sh
BACKEND_URL="https://jsonplaceholder.typicode.com" gleam run
```

Then, from another terminal:

```sh
curl -X POST http://localhost:8080/graphql \
  -H "content-type: application/json" \
  -d '{"query": "{ users/1 }"}'
```

## License

Copyright (C) 2026 AnmiTaliDev <anmitalidev@nuros.org>

Licensed under AGPL-3.0. See `LICENSE`.
