#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Uso: $0 <start-date YYYY-MM-DD> <end-date YYYY-MM-DD>"
  exit 1
fi

START_DATE="$1"
END_DATE="$2"

aws ce get-cost-and-usage \
  --time-period "Start=${START_DATE},End=${END_DATE}" \
  --granularity MONTHLY \
  --metrics UnblendedCost \
  --group-by Type=DIMENSION,Key=SERVICE
