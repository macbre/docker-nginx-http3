#!/bin/sh
docker run --rm \
  -p ::1:8888:80 \
  -p ::1:8889:443/tcp \
  -p ::1:8889:443/udp \
  -v "$PWD/tests":/static:ro \
  -v "$PWD/tests/static.conf":/etc/nginx/conf.d/static.conf:ro \
  -v "$PWD/tests/https.conf":/etc/nginx/conf.d/https.conf:ro \
  -v "$PWD/tests/localhost.crt":/etc/nginx/ssl/localhost.crt:ro \
  -v "$PWD/tests/localhost.key":/etc/nginx/ssl/localhost.key:ro \
 --name test_nginx \
  -t macbre/nginx
