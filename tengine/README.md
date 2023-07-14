# tengine


## 镜像包括


* [Tengine](https://tengine.taobao.org/) v2.4.1
    * [proxy_connect](http://tengine.taobao.org/document/proxy_connect.html)
* [LuaJIT2](https://github.com/openresty/luajit2) v2.1-20230410 

模块

* [ngx_devel_kit](https://github.com/simplresty/ngx_devel_kit) v0.3.2
* [nginx-upsync-module](https://github.com/weibocom/nginx-upsync-module) v2.1.3
* [set-misc-nginx-module](https://github.com/openresty/set-misc-nginx-module/) v0.33
* [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module)  0.34


相关

* [openresty](https://github.com/openresty)

## 用法

### 环境变量

### 运行

> 直接运行

```bash
$ docker run --rm -it -p 8080:80 xtulnx/nginx:tengine-latest
```

> 使用 docker-compose


```yaml
version: '3.3'
services:
  web:  
    image: xtulnx/nginx:tengine-latest
    volumes:
      - './conf.d:/etc/nginx/conf.d'
      - './html:/etc/nginx/html'
    ports:
      - "8001:80"
    network_mode: bridge
    # networks:
```


### 扩展

* 系统环境变量:

   ```
   $ env

   NGINX_BIN=/usr/sbin/nginx
   NGINX_PREFIX=/etc/nginx
   NGINX_CONFIG=/etc/nginx/conf.d
   NGINX_MODULE=/usr/lib/nginx/modules
   NGINX_CACHE=/var/cache/nginx
   NGINX_LOG=/var/log/nginx

   TENGINE_VERSION=2.4.1
   LUAJIT2_VERSION=2.1-20230410
   HEADERS_MORE_MODULE_VERSION=0.34
   UPSYNC_MODULE_VERSION=2.1.3
   SET_MISC_MODULE_VERSION=0.33
   NGX_DEVEL_KIT_VERSION=0.3.2
   ```

* 正向代理测试:

  ```
  server {
    listen 3182;

    # dns resolver used by forward proxying
    resolver  114.114.114.114;

    # forward proxy for CONNECT request
    proxy_connect;
    proxy_connect_allow            80 443 563;
    proxy_connect_connect_timeout  10s;
    proxy_connect_read_timeout     10s;
    proxy_connect_send_timeout     10s;

    # forward proxy for non-CONNECT request
    location / {
      proxy_pass $scheme://$http_host$request_uri;
      proxy_set_header Host $host;
    }
  }
  ```

  然后测试 `curl -x 127.0.0.1:3182 https://ipinfo.io`

* 正向代理 且 带 base auth 授权:

  1. 配置 conf/proxy.conf

    ```
    server {
      listen 81;
      auth_basic "server auth";
      auth_basic_user_file conf.d/proxy.pwd;

      # dns resolver used by forward proxying
      resolver  114.114.114.114;

      # forward proxy for CONNECT request
      proxy_connect;
      proxy_connect_allow            80 443 563;
      proxy_connect_connect_timeout  10s;
      proxy_connect_read_timeout     10s;
      proxy_connect_send_timeout     10s;

      rewrite_by_lua_file conf.d/proxy_auth.lua;

      # forward proxy for non-CONNECT request
      location / {
        proxy_pass $scheme://$http_host$request_uri;
        proxy_set_header Host $host;

        proxy_hide_header Authorization;
        proxy_hide_header Proxy-Authorization;
      }
    }
    ```

  2. 鉴权 lua: conf/proxy_auth.lua

    ```lua
    -- check Proxy-Authorization for https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/407
    local http_method = ngx.var.request_method
    if not ngx.var.http_proxy_authorization and http_method == "CONNECT" then
            ngx.header["Proxy-Authenticate"] = "Basic realm=\"Access to internal site\""
            ngx.exit(407)
    end
    -- transfer Proxy-Authorization header to Authorization for auth basic module
    if http_method == "CONNECT" then
            ngx.req.set_header("Authorization", ngx.var.http_proxy_authorization)
    end
    ```

  3. 添加账号

    ```
    htpasswd -cb conf/proxy.pwd hi world

    ```
  
  4. 验证

    ```
    # 未授权会失败
    # curl -x 127.0.0.1:81 https://ipinfo.io

    curl -x 127.0.0.1:81 --proxy-user hi:world https://ipinfo.io
    ```


## On DockerHub / GitHub

* Github [xtulnx/docker-build/nginx/tengine](https://github.com/xtulnx/docker-builder/tree/nginx/tengine)


## Thanks

* @nginxinc [docker-nginx](https://github.com/nginxinc/docker-nginx)
* @Axizdkr [tengine](https://github.com/Axizdkr/tengine)
