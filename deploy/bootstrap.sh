#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DATA_ROOT="${DATA_ROOT:-/opt/docker-projects-data/gps-medical-assistance}"

docker network inspect shared-edge >/dev/null 2>&1 || docker network create shared-edge

mkdir -p "$DATA_ROOT/postgres" "$DATA_ROOT/mongo" "$DATA_ROOT/uploads/UserFaceImage"

if [ "$(id -u)" -eq 0 ]; then
  chown -R 999:999 "$DATA_ROOT/postgres" "$DATA_ROOT/mongo"
else
  echo "Run this once if PostgreSQL/MongoDB cannot write their data directories:"
  echo "  sudo chown -R 999:999 $DATA_ROOT/postgres $DATA_ROOT/mongo"
fi

if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env from .env.example. Review POSTGRES_PASSWORD and Twilio settings."
fi

echo "gps-medical-assistance bootstrap complete."
echo "Next: docker compose up -d --build"
