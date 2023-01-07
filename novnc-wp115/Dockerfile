FROM debian:buster
LABEL authors="Jason.liao <xtulnx@126.com>"


##RUN echo "deb http://mirrors.aliyun.com/debian/ buster main non-free contrib\n" > /etc/apt/sources.list \
##  && echo "deb http://mirrors.aliyun.com/debian-security buster/updates main\n" >> /etc/apt/sources.list \
##  && echo "deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib\n" >> /etc/apt/sources.list \
##  && echo "deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib\n" >> /etc/apt/sources.list

# 环境变量
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
	\
    HOME=/root \
    LANG=C.UTF-8 \
    LANGUAGE=zh_CN:zh:en_US:en \
    LC_ALL=C.UTF-8 \
	\
	DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    RUN_XTERM=yes \
    RUN_FLUXBOX=yes

RUN set -ex; \
    apt-get update -qqy; \
    apt-get -qqy --no-install-recommends install \
      bash git unzip wget jq curl net-tools \
      xvfb x11vnc fluxbox supervisor xterm \
      novnc \
      locales \
      libglib2.0-0 fontconfig ttf-wqy-microhei \
       ; \
	\
	echo "https://pc.115.com/index.html#linux\n" \
	  && wget -q https://down.115.com/client/115pc/lin/115pc_2.0.2.9.deb -O /tmp/wp115.deb \
	  && dpkg -i /tmp/wp115.deb && rm -f /tmp/wp115.deb \
	\
    echo "清理安装的缓存" \
      && apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

WORKDIR /app/
COPY ./entrypoint.sh ./supervisord.conf /app/
COPY ./conf.d /app/conf.d
CMD ["/app/entrypoint.sh"]
EXPOSE 8080
