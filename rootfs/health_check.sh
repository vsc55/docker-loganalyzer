#!/bin/bash

PORT=${HTTP_PORT:-80}

curl -sf http://localhost:${PORT} > /dev/null || exit 1
exit 0