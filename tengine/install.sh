
TENGINE_VERSION=${TENGINE_VERSION:-2.3.3}

SRC=/usr/src

# https://github.com/openresty/luajit2
LUAJIT2_VERSION=${LUAJIT2_VERSION:-2.1-20220309}
LUAJIT_INCLUDE_VERSION=${LUAJIT_INCLUDE_VERSION:-${LUAJIT2_VERSION%%-*}}

# 模块
# https://github.com/simplresty/ngx_devel_kit
NGX_DEVEL_KIT_VERSION=${NGX_DEVEL_KIT_VERSION:-0.3.1}
# https://github.com/openresty/lua-nginx-module/
LUA_NGINX_MODULE_VERSION=${LUA_NGINX_MODULE_VERSION:-0.10.20}
# https://github.com/weibocom/nginx-upsync-module
UPSYNC_MODULE_VERSION=${UPSYNC_MODULE_VERSION:-2.1.3}
# https://github.com/openresty/headers-more-nginx-module
HEADERS_MORE_MODULE_VERSION=${HEADERS_MORE_MODULE_VERSION:-0.33}
# https://github.com/openresty/set-misc-nginx-module/
SET_MISC_MODULE_VERSION=${SET_MISC_MODULE_VERSION:-0.33}

NGINX_PREFIX=${NGINX_PREFIX:-/etc/nginx}
NGINX_BIN=${NGINX_BIN:-/usr/sbin/nginx}
NGINX_MODULE=${NGINX_MODULE:-/usr/lib/nginx/modules}
NGINX_CACHE=${NGINX_CACHE:-/var/cache/nginx}
NGINX_LOG=${NGINX_CACHE:-/var/log/nginx}

CONFIG=$(cat << EOF
--prefix=${NGINX_PREFIX} 
--sbin-path=${NGINX_BIN} 
--modules-path=${NGINX_MODULE} 
--conf-path=${NGINX_PREFIX}/nginx.conf 
--error-log-path=${NGINX_LOG}/error.log 
--http-log-path=${NGINX_LOG}/access.log 
--pid-path=/var/run/nginx.pid 
--lock-path=/var/run/nginx.lock 
--http-client-body-temp-path=${NGINX_CACHE}/client_temp 
--http-proxy-temp-path=${NGINX_CACHE}/proxy_temp 
--http-fastcgi-temp-path=${NGINX_CACHE}/fastcgi_temp 
--http-uwsgi-temp-path=${NGINX_CACHE}/uwsgi_temp 
--http-scgi-temp-path=${NGINX_CACHE}/scgi_temp 
--user=nginx 
--group=nginx 
--with-http_ssl_module 
--with-http_realip_module 
--with-http_addition_module 
--with-http_sub_module 
--with-http_dav_module 
--with-http_flv_module 
--with-http_mp4_module 
--with-http_gunzip_module 
--with-http_gzip_static_module 
--with-http_random_index_module 
--with-http_secure_link_module 
--with-http_stub_status_module 
--with-http_auth_request_module 
--with-http_xslt_module=dynamic 
--with-http_image_filter_module=dynamic 
--with-http_geoip_module=dynamic 
--with-threads 
--with-stream 
--with-stream_ssl_module 
--with-stream_ssl_preread_module 
--with-stream_realip_module 
--with-stream_geoip_module=dynamic 
--with-http_slice_module 
--with-mail 
--with-mail_ssl_module 
--with-compat 
--with-file-aio 
--with-http_v2_module 
--with-pcre 
--add-module=modules/ngx_http_upstream_check_module 
--add-module=modules/ngx_http_upstream_session_sticky_module 
--add-module=modules/headers-more-nginx-module-${HEADERS_MORE_MODULE_VERSION} 
--add-module=modules/ngx_devel_kit-${NGX_DEVEL_KIT_VERSION} 
--add-module=modules/lua-nginx-module-${LUA_NGINX_MODULE_VERSION} 
--add-module=modules/set-misc-nginx-module-${SET_MISC_MODULE_VERSION} 
--add-module=modules/nginx-upsync-module-${UPSYNC_MODULE_VERSION} 
--with-ld-opt=-Wl,-rpath,$SRC/luajit/lib
${CONFIG:-}
EOF
)

mkdir -p $SRC 

# tengine
[ -f "tengine-$TENGINE_VERSION.tar.gz" ] || curl -L "https://github.com/alibaba/tengine/archive/$TENGINE_VERSION.tar.gz" -o tengine-$TENGINE_VERSION.tar.gz 
tar -zxC $SRC -f tengine-$TENGINE_VERSION.tar.gz \
&& rm tengine-$TENGINE_VERSION.tar.gz 
[ $? -ne 0 ] && echo "tengine failed" && exit -1

# 模块 LuaJIT2
[ -f "luajit2-${LUAJIT2_VERSION}.tar.gz" ] || curl -L "https://github.com/openresty/luajit2/archive/v${LUAJIT2_VERSION}.tar.gz" -o "luajit2-${LUAJIT2_VERSION}.tar.gz"
rm -rf "luajit2-${LUAJIT2_VERSION}/" && tar -zxf "luajit2-${LUAJIT2_VERSION}.tar.gz" \
&& cd "luajit2-${LUAJIT2_VERSION}/" \
&& make -j$(getconf _NPROCESSORS_ONLN) && make install PREFIX=/usr/src/luajit \
&& cd .. \
&& rm -rf "luajit2-${LUAJIT2_VERSION}/" \
&& rm -rf "luajit2-${LUAJIT2_VERSION}.tar.gz" 
[ $? -ne 0 ] && echo "LuaJIT2 failed" && exit -1
export LUAJIT_LIB=$SRC/luajit/lib
export LUAJIT_INC=$SRC/luajit/include/luajit-${LUAJIT_INCLUDE_VERSION} 

# 模块 headers-more-nginx-module
[ -f "headers-more-nginx-module-${HEADERS_MORE_MODULE_VERSION}.tar.gz" ] || curl -L "https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_MODULE_VERSION}.tar.gz" -o headers-more-nginx-module-${HEADERS_MORE_MODULE_VERSION}.tar.gz 
tar -zxC $SRC/tengine-$TENGINE_VERSION/modules -f headers-more-nginx-module-${HEADERS_MORE_MODULE_VERSION}.tar.gz \
&& rm headers-more-nginx-module-${HEADERS_MORE_MODULE_VERSION}.tar.gz 
[ $? -ne 0 ] && echo "headers-more-nginx-module failed" && exit -1

# 模块 ngx_devel_kit
[ -f "ngx_devel_kit-${NGX_DEVEL_KIT_VERSION}.tar.gz" ] || curl -L "https://github.com/simplresty/ngx_devel_kit/archive/v${NGX_DEVEL_KIT_VERSION}.tar.gz" -o ngx_devel_kit-${NGX_DEVEL_KIT_VERSION}.tar.gz 
tar -zxC $SRC/tengine-$TENGINE_VERSION/modules -f ngx_devel_kit-${NGX_DEVEL_KIT_VERSION}.tar.gz \
&& rm ngx_devel_kit-${NGX_DEVEL_KIT_VERSION}.tar.gz
[ $? -ne 0 ] && echo "ngx_devel_kit failed" && exit -1

# 模块 lua-nginx-module
[ -f "lua-nginx-module-${LUA_NGINX_MODULE_VERSION}.tar.gz" ] || curl -L "https://github.com/openresty/lua-nginx-module/archive/v${LUA_NGINX_MODULE_VERSION}.tar.gz" -o lua-nginx-module-${LUA_NGINX_MODULE_VERSION}.tar.gz
tar -zxC $SRC/tengine-$TENGINE_VERSION/modules -f lua-nginx-module-${LUA_NGINX_MODULE_VERSION}.tar.gz \
&& rm lua-nginx-module-${LUA_NGINX_MODULE_VERSION}.tar.gz
[ $? -ne 0 ] && echo "lua-nginx-module failed" && exit -1

# 模块 set-misc-nginx-module
[ -f "set-misc-nginx-module-${SET_MISC_MODULE_VERSION}.tar.gz" ] || curl -L "https://github.com/openresty/set-misc-nginx-module//archive/v${SET_MISC_MODULE_VERSION}.tar.gz" -o set-misc-nginx-module-${SET_MISC_MODULE_VERSION}.tar.gz
tar -zxC $SRC/tengine-$TENGINE_VERSION/modules -f set-misc-nginx-module-${SET_MISC_MODULE_VERSION}.tar.gz \
&& rm set-misc-nginx-module-${SET_MISC_MODULE_VERSION}.tar.gz
[ $? -ne 0 ] && echo "set-misc-nginx-module failed" && exit -1

# 模块 nginx-upsync-module
[ -f "nginx-upsync-module-${UPSYNC_MODULE_VERSION}.tar.gz" ] || curl -L "https://github.com/weibocom/nginx-upsync-module/archive/v${UPSYNC_MODULE_VERSION}.tar.gz" -o nginx-upsync-module-${UPSYNC_MODULE_VERSION}.tar.gz
tar -zxC $SRC/tengine-$TENGINE_VERSION/modules -f nginx-upsync-module-${UPSYNC_MODULE_VERSION}.tar.gz \
&& rm nginx-upsync-module-${UPSYNC_MODULE_VERSION}.tar.gz
[ $? -ne 0 ] && echo "nginx-upsync-module failed" && exit -1

# Lua mysql:
# .....

ls -l $SRC/tengine-$TENGINE_VERSION/modules

cd "$SRC/tengine-$TENGINE_VERSION/" || exit -1

# 保留 debug 模式
# ./configure $CONFIG --with-debug  \
# && make -j$(getconf _NPROCESSORS_ONLN)  \
# && mv objs/nginx objs/nginx-debug \
# && mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so \
# && mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so \
# && mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so \
# && mv objs/ngx_stream_geoip_module.so objs/ngx_stream_geoip_module-debug.so
# [ $? -ne 0 ] && echo "build failed" && exit -1

# 正式模式
./configure $CONFIG \
&& make -j$(getconf _NPROCESSORS_ONLN) && make install
[ $? -ne 0 ] && echo "build failed" && exit -1

# mkdir -p "${NGINX_LOG}" && mkdir -p "${NGINX_CACHE}"

# rm -rf /etc/nginx/html/ \
mkdir /etc/nginx/conf.d/ 
mkdir -p /usr/share/nginx/html/ 
install -m644 html/* /usr/share/nginx/html/ 

# install -m755 objs/nginx-debug /usr/sbin/nginx-debug 
# install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module-debug.so 
# install -m755 objs/ngx_http_image_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_image_filter_module-debug.so 
# install -m755 objs/ngx_http_geoip_module-debug.so /usr/lib/nginx/modules/ngx_http_geoip_module-debug.so 
# install -m755 objs/ngx_stream_geoip_module-debug.so /usr/lib/nginx/modules/ngx_stream_geoip_module-debug.so 
# ln -s ../../usr/lib/nginx/modules /etc/nginx/modules 
# strip /usr/sbin/nginx* 
# strip /usr/lib/nginx/modules/*.so 

rm -rf "$SRC/tengine-$TENGINE_VERSION/"
 