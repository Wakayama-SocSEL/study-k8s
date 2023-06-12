#!/bin/bash
set -e

/add-server-id.sh
exec docker-entrypoint.sh "$@"