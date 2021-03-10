## What is this?

Stable and up-to-date [nginx](https://nginx.org/en/CHANGES) with [Google's `brotli` compression](https://github.com/google/ngx_brotli), [Lua module](https://github.com/openresty/lua-nginx-module), and [Grade A+ SSL config](https://ssl-config.mozilla.org/)


## How to use this image
As this project is based on the official [nginx image](https://hub.docker.com/_/nginx/) look for instructions there. In addition to the standard configuration directives, you'll be able to use the brotli module specific ones, see [here for official documentation](https://github.com/google/ngx_brotli#configuration-directives)

```
docker pull macbre/nginx-brotli:1.19.7
```

## What's inside

```
$ docker run -it macbre/nginx-brotli nginx -V
nginx version: nginx/1.19.7
built by gcc 10.2.1 20201203 (Alpine 10.2.1_pre1) 
built with OpenSSL 1.1.1j  16 Feb 2021
TLS SNI support enabled
configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-http_xslt_module=dynamic --with-http_image_filter_module=dynamic --with-http_geoip_module=dynamic --with-threads --with-stream --with-stream_ssl_module --with-stream_ssl_preread_module --with-stream_realip_module --with-stream_geoip_module=dynamic --with-http_slice_module --with-mail --with-mail_ssl_module --with-compat --with-file-aio --with-http_v2_module --add-module=/usr/src/ngx_brotli --with-ld-opt=-Wl,-rpath,/usr/lib --add-module=/tmp/ngx_devel_kit-0.3.1 --add-module=/tmp/lua-nginx-module-0.10.14
```

## SSL Grade A+ handling

Please refer to [Mozilla's SSL Configuration Generator](https://ssl-config.mozilla.org/). This image has `https://ssl-config.mozilla.org/ffdhe2048.txt` DH parameters for DHE ciphers fetched and stored in `/etc/ssl/dhparam.pem`:

```
    ssl_dhparam /etc/ssl/dhparam.pem;
```

## nginx config files includes

* `.conf` files mounted in `/etc/nginx/main.d` will be included in the `main` nginx context (e.g. you can call [`env` directive](http://nginx.org/en/docs/ngx_core_module.html#env) there)
* `.conf` files mounted in `/etc/nginx/conf.d` will be included in the `http` nginx context
