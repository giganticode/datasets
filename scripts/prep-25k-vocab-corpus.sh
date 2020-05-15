#!/bin/bash
set -euo pipefail

trap 'rm -rf .venv' EXIT

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "This stage cannot be run on OSx"
    exit 2
fi
codeprep_version=$(yq -r .codeprep_version params/25k-vocab-corpus.yml) 
virtualenv .venv 
source .venv/bin/activate 
pip install "codeprep==$codeprep_version" 
export XDG_CONFIG_HOME=$(pwd)/data/25k-vocab-corpus-prepped 
codeprep nosplit -p $(pwd)/data/25k-vocab-corpus --no-unicode --no-str --no-com --no-spaces --calc-vocab --verbose --output-path=$(pwd)/data/25k-vocab-corpus-prepped

