# https://github.com/coder/code-server/releases/latest
FROM codercom/code-server:4.92.2

LABEL MAINTAINER="skycc71640@gmail.com"

EXPOSE 8080

ARG TARGETARCH

ENV HOST="code-server"

USER root

# 安装常用工具并设置时区
RUN <<EOF
apt-get update && apt-get install -y \
    libssl-dev \
    build-essential \
    vim \
    dnsutils \
    net-tools \
    python3-full \
    python3-pip \
    pipx
rm -rf /var/lib/apt/lists/*
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' > /etc/timezone
EOF

# # 安装oh-my-zsh
# RUN git clone https://github.com/ohmyzsh/ohmyzsh.git /usr/share/oh-my-zsh && \
#     git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/zsh/plugins/zsh-autosuggestions && \
#     git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/zsh/plugins/zsh-syntax-highlighting

# 修改用户默认 shell
# RUN usermod -s /bin/zsh coder

# 安装依赖工具
COPY ./custom/install-tools-root.sh /opt/scripts/
RUN bash /opt/scripts/install-tools-root.sh 

# 添加start脚本
COPY ./custom/start.sh /opt/
RUN chmod +x /opt/start.sh && sed -i '/^exec/i /opt/start.sh' /usr/bin/entrypoint.sh

USER coder

# 安装依赖工具和插件
COPY ./custom/install-tools.sh /opt/scripts/
COPY ./custom/extensions /tmp/extensions
RUN bash /opt/scripts/install-tools.sh
