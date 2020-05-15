#!/usr/bin/env bash

set -e

DATASETS_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

PREFIX='./java_projects'

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ] || [ -z "$6" ]; then
    echo "Not all input params are spicified"
    exit 1
fi

archive_path="$DATASETS_ROOT_DIR/$1"
train_projects_file_path="$DATASETS_ROOT_DIR/$2"
valid_projects_file_path="$DATASETS_ROOT_DIR/$3"
test_projects_file_path="$DATASETS_ROOT_DIR/$4"
demo_file="$PREFIX/$5"
output_folder="$DATASETS_ROOT_DIR/$6"

if ! [ -d "$output_folder" ]; then
    mkdir "$output_folder"
fi

extract_project_bunch() {
    bunch="$1"
    projects_file_path="$2"

    echo "Extracting $bunch projects: "
    
    projects=$(< "$projects_file_path" tr '\n' ' ' | sed "s/ $//")
    echo "$projects"
    tar_parameter=$(echo " $projects" | sed "s~ ~ $PREFIX/~g")
    tar -xzf "$archive_path" -C "$output_folder" $tar_parameter
    mv "$output_folder/$PREFIX" "$output_folder/$bunch"
}

extract_project_bunch train "$train_projects_file_path"
extract_project_bunch valid "$valid_projects_file_path"
extract_project_bunch "test" "$test_projects_file_path"

echo "Extracting demo file: $demo_file"
tar -xzf "$archive_path" -C "$output_folder" "$demo_file"
mv "$output_folder/$PREFIX" "$output_folder/demo"

set +e
