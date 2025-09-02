#!/bin/bash
# .gitpod/start-novnc.sh
export DISPLAY=:0

# start X virtual framebuffer
Xvfb :0 -screen 0 1280x720x24 &>/tmp/xvfb.log &

# start window manager
fluxbox &>/tmp/fluxbox.log &

# start x11vnc (no password for demo; change for security)
x11vnc -display :0 -nopw -forever -shared -bg -o /tmp/x11vnc.log

# start noVNC websockify (map nic: 6080 -> vnc 5900)
# If /usr/bin/novnc_server exists you can use it. Otherwise run websockify.
if [ -f /usr/bin/novnc_server ]; then
  /usr/bin/novnc_server --vnc localhost:5900 --listen 6080 &>/tmp/novnc.log &
else
  /usr/bin/websockify --web=/usr/share/novnc/ 6080 localhost:5900 &>/tmp/novnc.log &
fi

echo "noVNC running at http://localhost:6080 (Gitpod will proxy this)"

