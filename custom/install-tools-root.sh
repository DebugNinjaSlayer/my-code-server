#!/usr/bin/env bash
# beased on debian https://github.com/coder/code-server/blob/e05d88007f0d8a8a14a371d070c5dd3b29582137/ci/release-image/Dockerfile#L3
echo "Installing tools for root"

# install docker
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# install ngrok
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc |
    gpg --dearmor -o /etc/apt/keyrings/ngrok.gpg &&
    echo "deb [signed-by=/etc/apt/keyrings/ngrok.gpg] https://ngrok-agent.s3.amazonaws.com buster main" |
    tee /etc/apt/sources.list.d/ngrok.list &&
    apt update
apt install ngrok
