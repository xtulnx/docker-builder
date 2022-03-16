# docker 编译发布

* 参考:
    * https://github.com/marketplace?type=actions
        * https://github.com/marketplace/actions/build-and-push-docker-images


> 个人学习记录:

* [noVNC 容器](https://github.com/xtulnx/docker-builder/tree/novnc/novnc)
    * vnc,自定义密码
    * 在容器中使用 vnc，支持自定义密码，可以作为基础镜像使用
* [tengine](https://github.com/xtulnx/docker-builder/tree/nginx/tengine)
    * nginx,tengine,淘宝,lua
    * 基于淘宝的 tengine，包括 lua 模块
* [tengine-nacos](https://github.com/xtulnx/docker-builder/tree/nginx/tengine-nacos)
    * nginx,tengine,淘宝,lua,nacos,集群
    * tengine + nacos ，用 nacos 来实时更新本地配置，可用于多个节点自动刷新nginx配置


