#!/usr/bin/env bash

directories=(
    "$PWD/coderhome/.config"
    "$PWD/coderhome/.local/share"
    "$PWD/coderhome/.pyenv"
    "$PWD/project"
)

files=(
    "$PWD/coderhome/gitconfig"
    "$PWD/coderhome/.wakatime.cfg"
)

for dir in "${directories[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "Creating directory: $dir"
        mkdir -p "$dir"
    fi
done

for file in "${files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Creating empty file: $file"
        touch "$file"
    fi
done

echo "Directory and file check complete."
