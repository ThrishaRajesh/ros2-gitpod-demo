
# .gitpod.Dockerfile
FROM osrf/ros:humble-desktop

ENV DEBIAN_FRONTEND=noninteractive
# install GUI tools + novnc + build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    x11vnc xvfb fluxbox supervisor wget git python3-colcon-common-extensions \
    novnc websockify && \
    rm -rf /var/lib/apt/lists/*

# put novnc in /opt/novnc (optional if installed via package)
RUN mkdir -p /opt/novnc || true

# create workspace location
RUN mkdir -p /workspace/ros2_ws
WORKDIR /workspace

# copy helper scripts
COPY .gitpod/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY .gitpod/start-novnc.sh /usr/local/bin/start-novnc.sh
RUN chmod +x /usr/local/bin/start-novnc.sh

# set display env
ENV DISPLAY=:0

# default cmd (supervisor will launch services)
CMD ["/usr/bin/supervisord","-n"]
