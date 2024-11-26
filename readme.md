## What is this?
[![Docker Image CI](https://github.com/macbre/docker-nginx-http3/actions/workflows/dockerimage.yml/badge.svg)](https://github.com/macbre/docker-nginx-http3/actions/workflows/dockerimage.yml)

Stable and up-to-date [nginx](https://nginx.org/en/CHANGES) with [QUIC + HTTP/3 support](https://nginx.org/en/docs/http/ngx_http_v3_module.html), [Google's `brotli` compression](https://github.com/google/ngx_brotli), [`zstd` compression](https://github.com/tokers/zstd-nginx-module), [`njs` module](https://nginx.org/en/docs/njs/), [kTLS/sendfile support](https://delthas.fr/blog/2023/kernel-tls/) and [Grade A+ SSL config](https://ssl-config.mozilla.org/)

## How to use this image
As this project is based on the official [nginx image](https://hub.docker.com/_/nginx/) look for instructions there. In addition to the standard configuration directives, you'll be able to use the brotli module specific ones, see [here for official documentation](https://github.com/google/ngx_brotli#configuration-directives)

```
docker pull macbre/nginx-http3:latest
```

You can fetch an image from [Github Containers Registry](https://github.com/macbre/docker-nginx-brotli/pkgs/container/nginx-http3) as well:

```
docker pull ghcr.io/macbre/nginx-http3:latest
```

## What's inside

* [built-in nginx modules](https://nginx.org/en/docs/)
* [`headers-more-nginx-module`](https://github.com/openresty/headers-more-nginx-module#readme) - sets and clears HTTP request and response headers
* [`ngx_brotli`](https://github.com/google/ngx_brotli#configuration-directives) - adds [brotli response compression](https://datatracker.ietf.org/doc/html/rfc7932)
* [`zstd-nginx-module`](https://github.com/tokers/zstd-nginx-module#directives) - adds [Zstandard response compression](https://datatracker.ietf.org/doc/html/rfc8878)
* [`ngx_http_geoip2_module`](https://github.com/leev/ngx_http_geoip2_module#download-maxmind-geolite2-database-optional) - creates variables with values from the maxmind geoip2 databases based on the client IP
* [`njs` module](https://nginx.org/en/docs/njs/) - a subset of the JavaScript language that allows extending nginx functionality ([GitHub repository](https://github.com/nginx/njs))

```
$ docker run -it macbre/nginx-http3 nginx -V
nginx version: nginx/1.27.3 (c7f94e6c96ee)
built by gcc 13.2.1 20240309 (Alpine 13.2.1_git20240309) 
built with OpenSSL 3.3.2 3 Sep 2024
TLS SNI support enabled
configure arguments: 
	--build=c7f94e6c96ee
	--prefix=/etc/nginx 
	--sbin-path=/usr/sbin/nginx 
	--modules-path=/usr/lib/nginx/modules 
	--conf-path=/etc/nginx/nginx.conf 
	--error-log-path=/var/log/nginx/error.log 
	--http-log-path=/var/log/nginx/access.log 
	--pid-path=/var/run/nginx/nginx.pid 
	--lock-path=/var/run/nginx/nginx.lock 
	--http-client-body-temp-path=/var/cache/nginx/client_temp 
	--http-proxy-temp-path=/var/cache/nginx/proxy_temp 
	--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp 
	--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp 
	--http-scgi-temp-path=/var/cache/nginx/scgi_temp 
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
	--with-http_perl_module=dynamic 
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
	--with-http_v3_module
	--with-openssl-opt=enable-ktls
	--add-module=/usr/src/ngx_brotli 
	--add-module=/usr/src/headers-more-nginx-module-0.37 
	--add-module=/usr/src/njs/nginx 
	--add-module=/usr/src/zstd
	--add-dynamic-module=/usr/src/ngx_http_geoip2_module
	--with-cc-opt='-g -O2 -flto=auto -ffat-lto-objects -flto=auto -ffat-lto-objects -I /usr/src/quickjs'
	--with-ld-opt='-Wl,-Bsymbolic-functions -flto=auto -ffat-lto-objects -flto=auto -L /usr/src/quickjs'

$ docker run -it macbre/nginx-http3 njs -v
0.8.7
```

## SSL Grade A+ handling

Please refer to [Mozilla's SSL Configuration Generator](https://ssl-config.mozilla.org/). This image has `https://ssl-config.mozilla.org/ffdhe2048.txt` DH parameters for DHE ciphers fetched and stored in `/etc/ssl/dhparam.pem`:

```
    ssl_dhparam /etc/ssl/dhparam.pem;
```

See [ssllabs.com test results for wbc.macbre.net](https://www.ssllabs.com/ssltest/analyze.html?d=wbc.macbre.net).

## nginx config files includes

* `.conf` files mounted in `/etc/nginx/main.d` will be included in the `main` nginx context (e.g. you can call [`env` directive](http://nginx.org/en/docs/ngx_core_module.html#env) there)
* `.conf` files mounted in `/etc/nginx/conf.d` will be included in the `http` nginx context

## QUIC + HTTP/3 support

<img width="577" alt="Screenshot 2021-05-19 at 16 31 10" src="https://user-images.githubusercontent.com/1929317/118840921-baf7d300-b8bf-11eb-8c0f-e57d573a28ce.png">

Please refer to `tests/https.conf` config file for an example config used by the tests. And to Cloudflare docs on [how to enable http/3 support in your browser](https://developers.cloudflare.com/http3/firefox).

```
server {
    # http/3
    listen 443 quic reuseport;

    # http/2 and http/1.1
    listen 443 ssl;
    http2 on;

    server_name localhost;  # customize to match your domain

    # you need to mount these files when running this container
    ssl_certificate     /etc/nginx/ssl/localhost.crt;
    ssl_certificate_key /etc/nginx/ssl/localhost.key;

    # TLSv1.3 is required for QUIC.
    ssl_protocols TLSv1.2 TLSv1.3;

    # 0-RTT QUIC connection resumption
    ssl_early_data on;

    # Add Alt-Svc header to negotiate HTTP/3.
    add_header alt-svc 'h3=":443"; ma=86400';

    # Sent when QUIC was used
    add_header QUIC-Status $http3;

    location / {
        # your config
    }
}
```

Refer to `run-docker.sh` script on how to run this container and properly mount required config files and assets.

## Development

Building an image:

```
docker pull ghcr.io/macbre/nginx-http3:latest
DOCKER_BUILDKIT=1 docker build . -t macbre/nginx --cache-from=ghcr.io/macbre/nginx-http3:latest --progress=plain
```

### Docker Compose example

It is necessary to expose both UDP and TCP ports to be able to HTTP/3

```yaml
  nginx:
    image: macbre/nginx-http3
    ports:
      - '443:443/tcp'
      - '443:443/udp' # use UDP for usage of HTTP/3
```

Note: both TCP and UDP HTTP/3 ports needs to be the same
