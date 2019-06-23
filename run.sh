#!/usr/bin/env bash

#PBS -q standard
##PBS -l select=1:ncpus=28:mem=168gb:pcmem=6gb
#PBS -l select=1:ncpus=24:mem=420gb:pcmem=42gb
#PBS -N runcntrf
#PBS -W group_list=mbsulli
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -j oe

module load singularity

set -u

BIN="/rsgrps/bhurwitz/hurwitzlab/tools/centrifuge-1.0.3-beta"
PATH="$BIN:$PATH"
INDEX_DIR="/rsgrps/bhurwitz/hurwitzlab/data/kyclark/clark_centrifuge/indexes"
DATA_DIR="/rsgrps/bhurwitz/hurwitzlab/data/kyclark/jet2"
OUT_DIR="/rsgrps/bhurwitz/hurwitzlab/data/kyclark/clark_centrifuge/centrifuge-out"
RUN="/rsgrps/bhurwitz/kyclark/centrifuge/scripts/run_centrifuge.py"
INDEX_NAME="clark"
EXCLUDE="" # "-x 9606,32630"
THREADS="12"
MAX_PROCS="8"

#IMG="$HOME/work/clark_centrifuge/centrifuge-1.0.4.img"
#RUN="singularity exec $IMG run_centrifuge.py"
#if [[ ! -f "$IMG" ]]; then
#    echo "Missing IMG \"$IMG\""
#    exit 1
#fi

echo "Started $(date)"
DIRS=$(mktemp)
find "$DATA_DIR" -mindepth 1 -maxdepth 1 -type d > "$DIRS"

NUM=$(wc -l "$DIRS" | awk '{print $1}')
echo "Found NUM \"$NUM\" dirs in DATA_DIR \"$DATA_DIR\""
cat -n "$DIRS"

if [[ $NUM -lt 1 ]]; then
    echo "Nothing to do!"
    exit 1
fi

i=0
while read -r DIR; do
    BASE=$(basename "$DIR")
    i=$((i+1))
    printf "%3d: %s\n" $i $BASE
    $RUN -q "$DIR" -i "$INDEX_NAME" -I "$INDEX_DIR" -o "$OUT_DIR/$BASE" \
        $EXCLUDE -P $MAX_PROCS -t $THREADS
done < "$DIRS"
rm "$DIRS"

echo "Ended $(date)"
