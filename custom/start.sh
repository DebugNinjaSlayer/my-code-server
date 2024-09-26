#!/usr/bin/env bash

echo "Install extensions"

sudo chown -R coder:coder /home/coder
cp -a /tmp/homebak/. /home/coder

for i in /tmp/extensions/*; do code-server --force --install-extension "$i"; done
extensions=(
    "golang.go"
    "k--kato.intellij-idea-keybindings"
    "vscjava.vscode-java-pack"
    "sonarsource.sonarlint-vscode"
    "hediet.vscode-drawio"
    "GitHub.vscode-github-actions"
    "esbenp.prettier-vscode"
    "dbaeumer.vscode-eslint"
    "WakaTime.vscode-wakatime"
    "ms-azuretools.vscode-docker"
    "Codeium.codeium"
    "bradlc.vscode-tailwindcss"
    "mtxr.sqltools"
    "mtxr.sqltools-driver-pg"
    "heybourn.headwind"
    "ms-python.python"
    "ms-python.autopep8"
    "eamodio.gitlens"
)
for ext in "${extensions[@]}"
do
    code-server --force --install-extension "$ext"
done
