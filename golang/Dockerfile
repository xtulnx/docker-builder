# # 使用官方的 golang 镜像作为基础镜像
# FROM golang:1.22.0
# LABEL authors="Jason.liao <xtulnx@126.com>"

# 使用适用于GLIBC 2.32以下版本的基础镜像
FROM debian:10
LABEL authors="Jason.liao <xtulnx@126.com>"

# RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz

RUN set -ex; \
    apt-get update -qqy; \
    apt-get -qqy --no-install-recommends install \
      ca-certificates build-essential libc6-dev gcc \
      bash git unzip wget jq curl net-tools \
      # libgcc \
      # https://github.com/confluentinc/librdkafka \
      librdkafka-dev \
      locales \
      #libglib2.0-0 \
    \
    && echo "https://go.dev/dl/\n" \
      && wget -q --no-check-certificate https://go.dev/dl/go1.22.0.linux-amd64.tar.gz -O /tmp/go.tar.gz \
      && tar -C /usr/local/ -xzf /tmp/go.tar.gz \
      && rm -f /tmp/go.tar.gz \
    \
    && echo "清理安装的缓存" \
      && apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && echo "ok"

ENV \
  GOPATH=/go\
  GOTOOLCHAIN=local\
  CGO_ENABLED=1\
  GOPROXY=https://proxy.golang.com.cn,direct\
  PATH=/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"

# 设置工作目录
WORKDIR /go/src

# 可以在这里添加一些其他的定制化设置，比如安装依赖、拷贝文件等

# 设置启动命令，比如启动一个简单的HTTP服务器
#CMD ["go", "run", "main.go"]
