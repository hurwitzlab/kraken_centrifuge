#!/usr/bin/env bash

#PBS -q standard
#PBS -l select=1:ncpus=48:mem=2016gb:pcmem=42gb
#PBS -N cntrfbld
#PBS -W group_list=bhurwitz
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -j oe

set -u

BIN="/rsgrps/bhurwitz/hurwitzlab/tools/centrifuge-1.0.3-beta"
PATH="$BIN:$PATH"
SEQID2TAX="/home/u20/kyclark/work/clark_centrifuge/seqid2taxid.map"
TAX_DIR="/rsgrps/bhurwitz/hurwitzlab/data/kyclark/clark_kraken/taxonomy/"
DATA_DIR="/rsgrps/bhurwitz/hurwitzlab/data/kyclark/clark_centrifuge"
INDEX_DIR="$DATA_DIR/indexes"
INPUT="$DATA_DIR/fasta/input.fna"
KRAKEN_DB="/rsgrps/bhurwitz/hurwitzlab/data/kyclark/kraken_db/library"

if [[ ! -f "$INPUT" ]]; then
    LIBS=$(find "$KRAKEN_DB" -name library.fna)
    cat $LIBS > "$INPUT"
fi

#if [[ ! -f "$SEQID2TAX" ]]; then
#    #centrifuge-download -o library -m -d "archaea,bacteria,viral" refseq > "$SEQID2TAX"
#    ./mk_seqid2taxid.py
#fi

echo "Started $(date)"
centrifuge-build --threads 40 \
    --conversion-table "$SEQID2TAX" \
    --taxonomy-tree "$TAX_DIR/nodes.dmp" \
    --name-table "$TAX_DIR/names.dmp" \
    "$INPUT" "$INDEX_DIR/clark"
echo "Ended $(date)"
