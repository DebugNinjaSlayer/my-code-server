#!/usr/bin/env bash

echo "Installing tools for common user"

pipx install pipenv
pipx ensurepath
pipx completions
curl https://pyenv.run | bash

# install nvm and nodejs
NVM_VERSION=v0.39.7
rm -rf /config/.nvm
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
cat <<'EOF' >>/root/.bashrc
# pnpm
export PNPM_HOME="/config/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
EOF

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

# install java, 
curl -s https://get.sdkman.io | bash
sdk install java 21.0.2-open
sdk use java 21.0.2-open