#!/bin/sh
podman  build --network host  --file container/arch.Dockerfile  --build-arg groupid=1000 --build-arg username=user -t nickel-arch
