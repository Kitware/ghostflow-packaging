from rust:latest as builder

arg APP
arg REF

# Create build script dir
run mkdir /build
workdir /build

# Install dependencies
copy --chmod=755 install.sh /build
run bash /build/install.sh --install $APP $REF

from rust:latest

arg APP

label org.opencontainers.image.authors="Ben Boeckel <ben.boeckel@kitware.com>, Brad King <brad.king@kitware.com>, Ryan Krattiger <ryan.krattiger@kitware.com>"

copy --from=builder /app /app

env RUST_LOG=$APP
env APP="$APP"

entrypoint /app/bin/${APP} $@
