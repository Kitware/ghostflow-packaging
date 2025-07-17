from rust:latest as builder

# Create build script dir
run mkdir /build
workdir /build

arg APP
arg REF

# Install dependencies
copy --chmod=755 install.sh /build
run bash /build/install.sh $APP $REF

from rust:latest

label org.opencontainers.image.authors="Ben Boeckel <ben.boeckel@kitware.com>, Brad King <brad.king@kitware.com>, Ryan Krattiger <ryan.krattiger@kitware.com>"

arg APP

copy --from=builder /app /app

env RUST_LOG=$APP
entrypoint ["/app/bin/$APP"]


