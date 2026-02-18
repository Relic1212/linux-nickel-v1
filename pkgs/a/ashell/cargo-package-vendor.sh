#!/bin/sh -e

src="$1"
shift 
dest="$1"
shift

echo "running \"cargo package $CARGO_ARGS\" in $src"

(cd "$src" && cargo package $CARGO_ARGS)

for f in $(find "$src" -name "*.crate" -type f); do
    tb="$f.tar.gz"
    mv "$f" "$tb"
    tbr=$(realpath "$tb")
    echo "unpacking $tbr"
    (cd "$dest" && tar xf "$tbr" --no-same-owner)
done
