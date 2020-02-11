#!/usr/bin/env bash
#

set -xeuo pipefail

export DOCKER_BUILDKIT=0
docker build \
  --progress=plain \
  --build-arg BUST_DOCKER_CACHE="${RANDOM}" \
  -t acl_normal \
  ./
