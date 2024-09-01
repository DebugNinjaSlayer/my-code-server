#!/usr/bin/env bash

echo "Appliying environment variables, install extensions"

# 修复权限问题，不这样修复的话，在服务器上创建出来是所属root用户的，后续无法正常启动。原因未知
echo "Ensure folders and permissions"
sudo mkdir -p /home/coder/.config /home/coder/.local /home/coder/project
sudo chown -R coder:coder /home/coder/.config /home/coder/.local /home/coder/project

cat >> ${HOME}/.bashrc <<'EOF'

# custom
PATH="$HOME/.local/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export DOCKER_HOST=tcp://${DOCKER_DIND_HOST:-docker}:2376
export DOCKER_CERT_PATH=${DOCKER_DIND_CERT_PATH:-"/certs/client"}
export DOCKER_TLS_VERIFY=1
EOF

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
)
for ext in "${extensions[@]}"
do
    code-server --force --install-extension "$ext"
done
