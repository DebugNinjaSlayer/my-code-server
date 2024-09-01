#!/usr/bin/env bash

echo "Installing tools for common user"

pipx install pipenv
pipx ensurepath
pipx completions
curl https://pyenv.run | bash

