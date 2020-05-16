#!/usr/bin/env bash

set -euo pipefail

DATASETS_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

CORPUS_DIR="$DATASETS_ROOT_DIR/$1"
OUTPUT_FILE="$DATASETS_ROOT_DIR/$2"

calc_metadata() {
    local _corpus
    _corpus="$1"

    local _size 
    _size=$(du -sm "$_corpus" | awk '{print $1}' )
    local _files 
    _files=$(find "$_corpus" -type f | wc -l)
    local _loc
    _loc=$(find "$_corpus" -type f  -exec wc -l {} + | awk '/total/{print $1}' | paste -sd+ /dev/stdin | bc)   
 
    local _json_string
    _json_string=$(jq -n \
        --argjson size_mb "$_size" \
        --argjson files "$_files" \
        --argjson loc "$_loc" \
        '{size_mb: $size_mb, files: $files, loc: $loc}' )

    echo "$_json_string"
}

TRAIN_STATS=$(calc_metadata "$CORPUS_DIR/train")
VALID_STATS=$(calc_metadata "$CORPUS_DIR/valid")
TEST_STATS=$(calc_metadata "$CORPUS_DIR/test")

JSON_STRING=$(jq -n \
    --argjson train_stats "$TRAIN_STATS" \
    --argjson valid_stats "$VALID_STATS" \
    --argjson test_stats "$TEST_STATS" \
    '{train: $train_stats, valid: $valid_stats, test: $test_stats}' )

echo "$CORPUS_DIR.metadata"
echo "$JSON_STRING" > "$OUTPUT_FILE"

