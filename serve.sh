#!/usr/bin/env bash
set -euo pipefail

# epm_registry/serve.sh — EPC service entry point
#
# EPC calls this script to start epm_registry as a persistent HTTP service.
# The server binds to the address/port declared in eps.toml [service].

cd "$(dirname "$0")"

bundle install --quiet

exec bundle exec rails server \
  --port "${PORT:-3001}" \
  --binding "${HOST:-127.0.0.1}" \
  --environment "${RAILS_ENV:-development}"
