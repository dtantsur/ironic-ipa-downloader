#!/bin/sh

set -eux

CONTAINER_RUNTIME="${CONTAINER_RUNTIME:-podman}"

if [ -z "${IS_CONTAINER:-}" ]; then
  TOP_DIR="${1:-.}"
  find "${TOP_DIR}" \
    -type f -name '*.sh' -exec shellcheck -s bash {} \+
else
  "${CONTAINER_RUNTIME}" run --rm \
    --env IS_CONTAINER=TRUE \
    --volume "${PWD}:/workdir:ro,z" \
    --entrypoint sh \
    --workdir /workdir \
    docker.io/koalaman/shellcheck-alpine:stable \
    /workdir/hack/shellcheck.sh "${@}"
fi