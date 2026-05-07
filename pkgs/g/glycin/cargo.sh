#!/bin/sh -e

echo "CARGO_WRAPPER: running \"$@\""

exec /usr/bin/cargo $@