# 网盘客户端

```
```

将 x11vnc + xvfb + vnc 通过 web 方式访问，网盘客户端。

## 镜像包括

* [Xvfb](http://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml) - X11 in a virtual framebuffer
* [x11vnc](http://www.karlrunge.com/x11vnc/) - A VNC server that scrapes the above X11 server
* [noNVC](https://kanaka.github.io/noVNC/) - A HTML5 canvas vnc viewer
* [Fluxbox](http://www.fluxbox.org/) - a small window manager
* [xterm](http://invisible-island.net/xterm/) - to demo that it works
* [supervisord](http://supervisord.org) - to keep it all running

中文字体:

* 文泉驿微米黑字体 fonts-wqy-microhei

[网盘官网](https://pc.115.com/index.html#linux)


## 用法

### 环境变量

* `DISPLAY=<display>` (:0.0)
* `DISPLAY_WIDTH=<width>` (1024)
* `DISPLAY_HEIGHT=<height>` (768)
* `RUN_XTERM={yes|no}` (yes)
* `RUN_FLUXBOX={yes|no}` (yes)

### 运行

> 直接运行:

```bash
$ docker run --rm -it -p 8080:8080 -v $(pwd)/data/downloads:/root/Downloads/115download xtulnx/novnc-wp115 
```

> 使用 docker-compose

```
version: "3.3"
services:
  wp115:
    image: "xtulnx/novnc-wp115:latest"
    container_name: wp115
    environment:
      # Adjust to your screen size
      - DISPLAY_WIDTH=1600
      - DISPLAY_HEIGHT=968
      - RUN_XTERM=no
    ports:
      - "8080:8080"
    volumes:
      - './data/downloads:/root/Downloads/115download/'
    networks:
      - x11
    restart: always
networks:
  x11:
```

> 然后打开浏览器: `http://<server>:8080/vnc.html`

### 扩展

* 后台服务:
  * 可重载 /app/supervisord.conf 或 /app/conf.d/ 来自定义后台服务。


## On DockerHub / GitHub
___

* GitHub [xtulnx/docker-builder/novnc](https://github.com/xtulnx/docker-builder/tree/novnc)

# Thanks
___

* @theasp [docker-novnc](https://github.com/theasp/docker-novnc)
* @psharkey [novnc](https://github.com/psharkey/docker/tree/master/novnc)
