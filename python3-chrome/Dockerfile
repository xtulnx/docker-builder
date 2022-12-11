FROM ubuntu:20.04
LABEL authors="Jason.liao <xtulnx@126.com>"
USER root

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    \
    HOME=/root \
    LANG=C.UTF-8 \
    LANGUAGE=zh_CN:zh:en_US:en \
    LC_ALL=C.UTF-8 \
    \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768

RUN apt-get update -qqy && apt-get -qqy install wget gnupg \
  unzip wget jq curl net-tools \
  xvfb supervisor xterm \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# RUN apt-get install -y wget
# RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# RUN apt-get install ./google-chrome-stable_current_amd64.deb

#============================================
# Google Chrome
#============================================
# can specify versions by CHROME_VERSION;
#  e.g. google-chrome-stable=53.0.2785.101-1
#       google-chrome-beta=53.0.2785.92-1
#       google-chrome-unstable=54.0.2840.14-1
#       latest (equivalent to google-chrome-stable)
#       google-chrome-beta  (pull latest beta)
# https://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable
#============================================
ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    ${CHROME_VERSION:-google-chrome-stable} \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# 安装 python 
RUN apt-get update -qqy \
  && apt-get install -qqy software-properties-common \
  && add-apt-repository ppa:deadsnakes/ppa \
  && apt-get install -qqy python3.10 \
  && apt-get install -qqy python3-pip \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

WORKDIR /app/

ENV CHROME_DRIVER /app/chromedriver

COPY ./requirements.txt ./install.py ./entrypoint.sh ./supervisord.conf /app/
COPY ./conf.d /app/conf.d

RUN mkdir -p /app/data /app/web /app/conf2.d \
  && pip install -r /app/requirements.txt \
  && python3 /app/install.py "${CHROME_DRIVER}" 108 \
  && rm -rf /app/requirements.txt /app/install.py

CMD ["/app/entrypoint.sh"]
EXPOSE 8080 5000
STOPSIGNAL SIGTERM
