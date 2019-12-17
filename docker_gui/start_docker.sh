docker run -it \
  -v /etc/localtime:/etc/localtime:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=:0.0 \
  --name guitest \
  ubuntu:18.04 \
  /bin/bash


  -e GDK_SCALE \
  -e GDK_DPI_SCALE \


