#!/bin/sh
while IFS= read -r body; do
  out=$(wget -q -T {{ .Values.laya.timeoutSeconds }} -O - \
    --header 'Content-Type: application/json' \
    --post-data "$body" {{ .Values.laya.url | quote }} 2>/dev/null | tr -d '\n')
  [ -n "$out" ] || out='{}'
  printf '%s\n' "$out"
done
