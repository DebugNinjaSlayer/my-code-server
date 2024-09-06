#!/usr/bin/env bash

echo "Installing tools for common user"

pipx install pipenv
pipx ensurepath
pipx completions
curl https://pyenv.run | bash

# install nvm and nodejs
NVM_VERSION=v0.39.7
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> $HOME/.bashrc
. $HOME/.bashrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install --lts
nvm use --lts

# install pnpm
export SHELL=bash
curl -fsSL https://get.pnpm.io/install.sh | sh -

# install yarn
npm install --global yarn

# install golang
GOLANG_VERSION=1.22.3
curl -OL https://go.dev/dl/go$GOLANG_VERSION.linux-arm64.tar.gz
sudo tar -C /usr/local -xf go$GOLANG_VERSION.linux-arm64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >>  $HOME/.bashrc
rm go$GOLANG_VERSION.linux-arm64.tar.gz

# install maven
MAVEN_VERSION=3.9.7
curl -OL https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
tar -xf apache-maven-$MAVEN_VERSION-bin.tar.gz
sudo mv apache-maven-$MAVEN_VERSION /opt/
echo "M2_HOME='/opt/apache-maven-$MAVEN_VERSION'" >> $HOME/.bashrc
echo 'PATH="$M2_HOME/bin:$PATH"' >> $HOME/.bashrc
echo 'export PATH' >> $HOME/.bashrc
rm apache-maven-$MAVEN_VERSION-bin.tar.gz

# install jdk
curl -s https://get.sdkman.io | bash
. "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 21.0.2-open
sdk default java 21.0.2-open

cat << 'EOF' >> $HOME/.bashrc

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

cp -a /home/coder /tmp/homebak