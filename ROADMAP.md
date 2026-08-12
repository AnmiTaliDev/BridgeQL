# Roadmap

BridgeQL is a learning project and currently implements only the minimal core described in `README.md`. Everything below was intentionally left out of the initial version to keep the scope small and the code readable. None of it is planned on any particular timeline, this is just an honest list of what a "real" version would need.

## GraphQL support

- [ ] Real GraphQL query parsing (the current implementation only reads a single bare field name out of `{ field }`)
- [ ] Multiple fields per query
- [ ] Query arguments and variables
- [ ] Nested selections and nested resolvers
- [ ] Mutations
- [ ] Subscriptions
- [ ] Schema definition and introspection
- [ ] Proper GraphQL error responses (`errors` array, error codes, locations)

## Proxying and backend integration

- [ ] Multiple configurable backends / multiple REST endpoints
- [ ] Request retry logic and backoff
- [ ] Response caching
- [ ] Request/response timeouts configurable per route
- [ ] Passing through query parameters, headers, and request bodies beyond the field path
- [ ] Content negotiation (only JSON is assumed today)

## Reliability and operations

- [ ] Authentication and authorization (both for clients calling BridgeQL and for BridgeQL calling the backend)
- [ ] Rate limiting
- [ ] Structured logging and request tracing
- [ ] Metrics and health check endpoints
- [ ] Graceful shutdown handling beyond what `mist` provides by default

## Quality and delivery

- [ ] Automated tests (unit and integration)
- [ ] CI/CD pipeline
- [ ] Docker image / containerized deployment
- [ ] Configuration via a config file in addition to environment variables
- [ ] Versioned API surface
