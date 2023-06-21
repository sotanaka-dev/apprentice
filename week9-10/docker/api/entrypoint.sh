#!/bin/bash
set -e

rm -f /real-world/tmp/pids/server.pid

exec "$@"
