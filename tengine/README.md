# tengine


## 镜像包括


* [Tengine](https://tengine.taobao.org/)
* [LuaJIT2](https://github.com/openresty/luajit2)

模块

* [ngx_devel_kit](https://github.com/simplresty/ngx_devel_kit) v0.3.1
* [nginx-upsync-module](https://github.com/weibocom/nginx-upsync-module) v2.1.3
* [lua-nginx-module](https://github.com/openresty/lua-nginx-module) 0.10.20
* [set-misc-nginx-module](https://github.com/openresty/set-misc-nginx-module/) v0.33
* [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module)  0.33


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

   TENGINE_VERSION=2.3.3
   LUAJIT2_VERSION=2.1-20220309
   HEADERS_MORE_MODULE_VERSION=0.33
   UPSYNC_MODULE_VERSION=2.1.3
   SET_MISC_MODULE_VERSION=0.33
   NGX_DEVEL_KIT_VERSION=0.3.1
   LUA_NGINX_MODULE_VERSION=0.10.20
   ```

## On DockerHub / GitHub

* Github [xtulnx/docker-build/nginx/tengine](https://github.com/xtulnx/docker-builder/tree/nginx/tengine)


## Thanks

* @nginxinc [docker-nginx](https://github.com/nginxinc/docker-nginx)
* @Axizdkr [tengine](https://github.com/Axizdkr/tengine)
