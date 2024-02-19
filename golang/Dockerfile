# 使用官方的 golang 镜像作为基础镜像
FROM golang:1.22.0
LABEL authors="Jason.liao <xtulnx@126.com>"

# RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
RUN set -ex; \
    apt-get update -qqy; \
    apt-get -qqy --no-install-recommends install \
      librdkafka-dev \
      #bash git unzip wget jq curl net-tools \
      locales \
      libglib2.0-0 \
       ; \
    echo "清理安装的缓存" \
      && apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# 设置工作目录
WORKDIR /go/src

# 可以在这里添加一些其他的定制化设置，比如安装依赖、拷贝文件等

# 设置启动命令，比如启动一个简单的HTTP服务器
#CMD ["go", "run", "main.go"]
