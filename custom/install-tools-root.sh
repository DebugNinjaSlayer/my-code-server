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
apt-get install -y ngrok

apt-get install -y tor iputils-ping tree

# support remotion https://github.com/remotion-dev/remotion/issues/3808#issuecomment-2086300700
apt-get install -y gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 \
    libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 \
    libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
    libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation \
    libnss3 lsb-release xdg-utils wget libgbm-dev

# install sshd
apt-get install -y openssh-server
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i '/^PubkeyAuthentication yes/a TrustedUserCAKeys /etc/ssh/ca.pub' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

cat <<EOF >> /etc/ssh/sshd_config
Match user coder
  AuthorizedPrincipalsCommand /bin/echo 'skycc71640'
  AuthorizedPrincipalsCommandUser nobody
EOF

cat <<EOF >> /etc/ssh/ca.pub
ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGiLhNjaDRnZvyQmBOZBwuPxz0vs/SP53L+oKZAha2F15ieBk4ynDrUAZRZdNwh/5+tzkdWnSnCUEtdmIZoC/OI= open-ssh-ca@cloudflareaccess.org
EOF

mkdir -p /run/sshd
chmod 755 /run/sshd