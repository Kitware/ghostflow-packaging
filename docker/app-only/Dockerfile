from rust:latest

arg APP

copy --from=$APP-builder /app /app

env RUST_LOG=$APP
entrypoint ["/app/bin/$APP"]

