#!/bin/bash
set -ex

RUN_FLUXBOX=${RUN_FLUXBOX:-yes}
RUN_XTERM=${RUN_XTERM:-yes}
VNC_PASSWORD=${VNC_PASSWORD:-}

case $RUN_FLUXBOX in
  false|no|n|0)
    rm -f /app/conf.d/fluxbox.conf
    ;;
esac

case $RUN_XTERM in
  false|no|n|0)
    rm -f /app/conf.d/xterm.conf
    ;;
esac

if [ -n "$VNC_PASSWORD" ]; then
  x11vnc -storepasswd "${VNC_PASSWORD}" /app/conf.d/x11vnc.pass
  sed -i '/^command=/s;$; -rfbauth /app/conf.d/x11vnc.pass;' /app/conf.d/x11vnc.conf
fi

exec supervisord -c /app/supervisord.conf
