#!/bin/sh

cat ${1}/drv.json|jq ".[\"name\"]"
