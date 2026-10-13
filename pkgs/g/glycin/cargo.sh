#!/bin/sh -e

echo "CARGO_WRAPPER: running \"$@\""

exec /usr/bin/cargo --target x86_64-unknown-musl $@