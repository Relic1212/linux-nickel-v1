#!/bin/sh

cat build/latest/drv.json|jq ".[\"name\"]"
