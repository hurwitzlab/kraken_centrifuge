#!/usr/bin/env bash

FILES=$(mktemp)
DIR="/rsgrps/bhurwitz/hurwitzlab/data/kyclark/clark_centrifuge/centrifuge-out"
find "$DIR" -name bubble.pdf > "$FILES"

OUT_DIR="plots"
[[ ! -d "$OUT_DIR" ]] && mkdir -p "$OUT_DIR"

while read -r FILE; do
    DIR=$(basename $(dirname $(dirname "$FILE")))
    cp "$FILE" "$OUT_DIR/$DIR.pdf"
done < "$FILES"

rm "$FILES"
