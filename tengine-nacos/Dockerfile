FROM alpine:3.15
LABEL authors="Jason.liao <xtulnx@126.com>"

# https://github.com/alibaba/tengine
ENV TENGINE_VERSION 2.3.3
# https://github.com/openresty/luajit2
ENV LUAJIT2_VERSION 2.1-20220309 
# https://github.com/simplresty/ngx_devel_kit
ENV NGX_DEVEL_KIT_VERSION 0.3.1
# # https://github.com/openresty/lua-nginx-module/
# ENV LUA_NGINX_MODULE_VERSION 0.10.13
# https://github.com/weibocom/nginx-upsync-module
ENV UPSYNC_MODULE_VERSION 2.1.3
# https://github.com/openresty/headers-more-nginx-module
ENV HEADERS_MORE_MODULE_VERSION 0.33
# https://github.com/openresty/set-misc-nginx-module/
ENV SET_MISC_MODULE_VERSION 0.33

# https://github.com/xtulnx/go-ali-nacos
ENV J00_NACOS 1.1.0

ENV NGINX_PREFIX /etc/nginx
ENV NGINX_BIN /usr/sbin/nginx
ENV NGINX_MODULE /usr/lib/nginx/modules
ENV NGINX_CACHE /var/cache/nginx
ENV NGINX_LOG /var/log/nginx
ENV NGINX_CONFIG ${NGINX_PREFIX}/conf.d


# nginx: https://git.io/vSIyj

RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*


ENV CONFIG "\
        --prefix=${NGINX_PREFIX} \
        --sbin-path=${NGINX_BIN} \
        --modules-path=${NGINX_MODULE} \
        --conf-path=${NGINX_PREFIX}/nginx.conf \
        --error-log-path=${NGINX_LOG}/error.log \
        --http-log-path=${NGINX_LOG}/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=${NGINX_CACHE}/client_temp \
        --http-proxy-temp-path=${NGINX_CACHE}/proxy_temp \
        --http-fastcgi-temp-path=${NGINX_CACHE}/fastcgi_temp \
        --http-uwsgi-temp-path=${NGINX_CACHE}/uwsgi_temp \
        --http-scgi-temp-path=${NGINX_CACHE}/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-http_xslt_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-http_geoip_module=dynamic \
        --with-threads \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-stream_realip_module \
        --with-stream_geoip_module=dynamic \
        --with-http_slice_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-compat \
        --with-file-aio \
        --with-http_v2_module \
        --with-pcre \
        --add-module=modules/ngx_http_upstream_check_module \
        --add-module=modules/ngx_http_upstream_session_sticky_module \
        # 换成内置的
        # --add-module=modules/lua-nginx-module-${LUA_NGINX_MODULE_VERSION} \
        --add-module=modules/ngx_http_lua_module \
        # 放在依赖的模块编译后添加
        # --with-ld-opt=-Wl,-rpath,/usr/src/luajit/lib \
        --add-module=modules/headers-more-nginx-module-${HEADERS_MORE_MODULE_VERSION} \
        --add-module=modules/ngx_devel_kit-${NGX_DEVEL_KIT_VERSION} \
        --add-module=modules/set-misc-nginx-module-${SET_MISC_MODULE_VERSION} \
        --add-module=modules/nginx-upsync-module-${UPSYNC_MODULE_VERSION} \
        "


RUN     set -x \
        && addgroup -g 101 -S nginx \
        && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
        && adduser -u 82 -D -S -G www-data www-data \
        && apk add --no-cache --virtual .build-deps \
                gcc \
                libc-dev \
                make \
                openssl-dev \
                pcre-dev \
                zlib-dev \
                linux-headers \
                curl \
                libxslt-dev \
                gd-dev \
                geoip-dev \
        \
        # 下载 安装 相关模块
        && SRC=/usr/src && mkdir -p $SRC && mkdir -p /app \
        # tengine
        && curl -L "https://github.com/alibaba/tengine/archive/$TENGINE_VERSION.tar.gz" -o tengine-$TENGINE_VERSION.tar.gz  \
        && tar -zxC $SRC -f tengine-$TENGINE_VERSION.tar.gz \
        && rm tengine-$TENGINE_VERSION.tar.gz \
        # 模块 LuaJIT2
        && LUAJIT_INCLUDE_VERSION=${LUAJIT_INCLUDE_VERSION:-${LUAJIT2_VERSION%%-*}} \
        && LUAJIT_INSTALL=/usr/local/luajit \
        && curl -L "https://github.com/openresty/luajit2/archive/v${LUAJIT2_VERSION}.tar.gz" -o "luajit2-${LUAJIT2_VERSION}.tar.gz" \
        && rm -rf "luajit2-${LUAJIT2_VERSION}/" && tar -zxf "luajit2-${LUAJIT2_VERSION}.tar.gz" \
        && cd "luajit2-${LUAJIT2_VERSION}/" \
        && make -j$(getconf _NPROCESSORS_ONLN) && make install PREFIX=${LUAJIT_INSTALL} \
        && cd .. \
        && rm -rf "luajit2-${LUAJIT2_VERSION}/" && rm -rf "luajit2-${LUAJIT2_VERSION}.tar.gz" \
        && export LUAJIT_LIB=${LUAJIT_INSTALL}/lib \
        && export LUAJIT_INC=${LUAJIT_INSTALL}/include/luajit-${LUAJIT_INCLUDE_VERSION} \
        # 模块 headers-more-nginx-module
        && curl -L "https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_MODULE_VERSION}.tar.gz" -o headers-more-nginx-module-${HEADERS_MORE_MODULE_VERSION}.tar.gz \
        && tar -zxC $SRC/tengine-$TENGINE_VERSION/modules -f headers-more-nginx-module-${HEADERS_MORE_MODULE_VERSION}.tar.gz \
        && rm headers-more-nginx-module-${HEADERS_MORE_MODULE_VERSION}.tar.gz \
        # 模块 ngx_devel_kit
        && curl -L "https://github.com/simplresty/ngx_devel_kit/archive/v${NGX_DEVEL_KIT_VERSION}.tar.gz" -o ngx_devel_kit-${NGX_DEVEL_KIT_VERSION}.tar.gz \
        && tar -zxC $SRC/tengine-$TENGINE_VERSION/modules -f ngx_devel_kit-${NGX_DEVEL_KIT_VERSION}.tar.gz \
        && rm ngx_devel_kit-${NGX_DEVEL_KIT_VERSION}.tar.gz \
        # # 模块 lua-nginx-module
        # && curl -L "https://github.com/openresty/lua-nginx-module/archive/v${LUA_NGINX_MODULE_VERSION}.tar.gz" -o lua-nginx-module-${LUA_NGINX_MODULE_VERSION}.tar.gz \
        # && tar -zxC $SRC/tengine-$TENGINE_VERSION/modules -f lua-nginx-module-${LUA_NGINX_MODULE_VERSION}.tar.gz \
        # && rm lua-nginx-module-${LUA_NGINX_MODULE_VERSION}.tar.gz \
        # 模块 set-misc-nginx-module
        && curl -L "https://github.com/openresty/set-misc-nginx-module//archive/v${SET_MISC_MODULE_VERSION}.tar.gz" -o set-misc-nginx-module-${SET_MISC_MODULE_VERSION}.tar.gz \
        && tar -zxC $SRC/tengine-$TENGINE_VERSION/modules -f set-misc-nginx-module-${SET_MISC_MODULE_VERSION}.tar.gz \
        && rm set-misc-nginx-module-${SET_MISC_MODULE_VERSION}.tar.gz \
        # 模块 nginx-upsync-module
        && curl -L "https://github.com/weibocom/nginx-upsync-module/archive/v${UPSYNC_MODULE_VERSION}.tar.gz" -o nginx-upsync-module-${UPSYNC_MODULE_VERSION}.tar.gz \
        && tar -zxC $SRC/tengine-$TENGINE_VERSION/modules -f nginx-upsync-module-${UPSYNC_MODULE_VERSION}.tar.gz \
        && rm nginx-upsync-module-${UPSYNC_MODULE_VERSION}.tar.gz \
        # Lua mysql:
        # .....
        && ls -l $SRC/tengine-$TENGINE_VERSION/modules \
        && cd "$SRC/tengine-$TENGINE_VERSION/" \
        # 正式编译
        && ./configure $CONFIG --with-ld-opt=-Wl,-rpath,$LUAJIT_LIB \
        && make -j$(getconf _NPROCESSORS_ONLN) && make install \
        && cd - && rm -rf "$SRC/tengine-$TENGINE_VERSION/" \
        && mkdir -p ${NGINX_CACHE} \
        && mkdir -p ${NGINX_CONFIG} \
        \
        && curl -L "https://github.com/xtulnx/go-ali-nacos/releases/download/v${J00_NACOS}/ali-nacos-${J00_NACOS}-linux-386.tgz" -o ali-nacos-${J00_NACOS}.tgz \
        && tar -xzC /app/ -f ali-nacos-${J00_NACOS}.tgz \
        && chmod u+x /app/ali-nacos \
        && rm -rf "ali-nacos-${J00_NACOS}.tgz" \
        \
        # Bring in gettext so we can get `envsubst`, then throw
        # the rest away. To do this, we need to install `gettext`
        # then move `envsubst` out of the way so `gettext` can
        # be deleted completely, then move `envsubst` back.
        && apk add --no-cache --virtual .gettext gettext \
        && mv /usr/bin/envsubst /tmp/ \
        \
        && runDeps="$( \
                scanelf --needed --nobanner --format '%n#p' ${NGINX_BIN} ${NGINX_MODULE}/*.so /tmp/envsubst \
                        | tr ',' '\n' \
                        | sort -u \
                        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        )" \
        && apk add --no-cache --virtual .nginx-rundeps $runDeps \
        && apk del .build-deps \
        && apk del .gettext \
        && mv /tmp/envsubst /usr/local/bin/ \
        \
        # Bring in tzdata so users could set the timezones through the environment
        # variables
        && apk add --no-cache tzdata \
        \
        # forward request and error logs to docker log collector
        && mkdir -p "${NGINX_LOG}" \
        && ln -sf /dev/stdout ${NGINX_LOG}/access.log \
        && ln -sf /dev/stderr ${NGINX_LOG}/error.log

WORKDIR /app/

COPY ./entrypoint.sh /app/
COPY nginx.conf ${NGINX_PREFIX}/nginx.conf
COPY ./conf.d/ ${NGINX_CONFIG}/

# VOLUME ${NGINX_CONFIG}
# VOLUME ${NGINX_PREFIX}/html

EXPOSE 80 443
STOPSIGNAL SIGTERM
CMD ["sh","/app/entrypoint.sh"]
