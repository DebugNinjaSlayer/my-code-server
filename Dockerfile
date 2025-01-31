# https://github.com/coder/code-server/releases/latest
FROM codercom/code-server:4.95.3

LABEL MAINTAINER="oddcc@gmail.com"

EXPOSE 8080

ARG TARGETARCH

ENV HOST="code-server"

USER root

# https://doc.scrapy.org/en/latest/intro/install.html#ubuntu-14-04-or-above
RUN <<EOF
apt-get update && apt-get install -y \
    build-essential \
    unzip \
    zip \
    vim \
    dnsutils \
    net-tools \
    python3-full \
    pipx

apt-get install -y zlib1g libbz2-dev libsqlite3-dev libreadline-dev lzma liblzma-dev
apt-get install -y python3 python3-dev python3-pip libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev
rm -rf /var/lib/apt/lists/*
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' > /etc/timezone
EOF

# # 安装oh-my-zsh
# RUN git clone https://github.com/ohmyzsh/ohmyzsh.git /usr/share/oh-my-zsh && \
#     git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/zsh/plugins/zsh-autosuggestions && \
#     git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/zsh/plugins/zsh-syntax-highlighting

# 修改用户默认 shell
# RUN usermod -s /bin/zsh coder

COPY ./custom/install-tools-root.sh /opt/scripts/
RUN bash /opt/scripts/install-tools-root.sh 

COPY ./custom/start.sh /opt/
RUN chmod +x /opt/start.sh && sed -i '/^exec/i /opt/start.sh' /usr/bin/entrypoint.sh

USER coder

COPY ./custom/install-tools.sh /opt/scripts/
COPY ./custom/extensions /tmp/extensions
RUN bash /opt/scripts/install-tools.sh
