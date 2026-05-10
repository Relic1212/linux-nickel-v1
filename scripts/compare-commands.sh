#!/bin/sh -e

f1=$(mktemp)
f2=$(mktemp)


ls "build/tmp/${1}/out/destdir/usr/bin" > "$f1"
ls "build/tmp/${2}/out/destdir/usr/bin" > "$f2"

diff --side-by-side "$f1" "$f2"

