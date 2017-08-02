#!/bin/bash
cd /tmp/

RESTY_VERSION="1.11.2.1"
RESTY_OPENSSL_VERSION="1.0.2j"
PAGESPEED_VERSION="1.11.33.4"

RESTY_CONFIG_OPTIONS="\
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_gzip_static_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-file-aio \
    --with-ipv6 \
    --with-pcre-jit \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads \
    --without-http_autoindex_module \
    --without-http_browser_module \
    --without-http_userid_module \
    --without-http_split_clients_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module \
    --without-http_referer_module \
     --user=nginx \
     --group=nginx \
    --sbin-path=/usr/sbin \
    --modules-path=/usr/lib/nginx \
    --prefix=/etc/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx/nginx.lock \
    --http-fastcgi-temp-path=/tmp/nginx/fastcgi \
    --http-proxy-temp-path=/tmp/nginx/proxy \
    --http-client-body-temp-path=/tmp/nginx/client_body \
    --add-module=/tmp/ngx_pagespeed-${PAGESPEED_VERSION}-beta \
    --with-openssl=/tmp/openssl-${RESTY_OPENSSL_VERSION} \
    "


### Download Tarballs ###
# Download PageSpeed
echo "Downloading PageSpeed..."
curl -sL https://github.com/pagespeed/ngx_pagespeed/archive/v${PAGESPEED_VERSION}-beta.tar.gz | tar -zx

# psol needs to be inside ngx_pagespeed module
# Download PageSpeed Optimization Library and extract it to nginx source dir
cd /tmp/ngx_pagespeed-${PAGESPEED_VERSION}-beta/
echo "Downloading PSOL..."
curl -sL https://dl.google.com/dl/page-speed/psol/${PAGESPEED_VERSION}.tar.gz | tar -zx

cd /tmp/

# Download OpenSSL
echo "Downloading OpenSSL..."
curl -sL https://www.openssl.org/source/openssl-${RESTY_OPENSSL_VERSION}.tar.gz | tar -zx

# Download Openresty bundle
echo "Downloading openresty..."
curl -sL https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz | tar -zx

# Download custom redis module with AUTH support
echo "Downloading ngx_http_redis..."
curl -sL https://github.com/onnimonni/ngx_http_redis-0.3.7/archive/master.tar.gz | tar -zx

# Use all cores available in the builds with -j${NPROC} flag
readonly NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)
echo "using up to $NPROC threads"

### Configure Nginx ###
cd openresty-${RESTY_VERSION}
./configure -j${NPROC} ${_RESTY_CONFIG_DEPS} ${RESTY_CONFIG_OPTIONS}

# Build Nginx
make -j${NPROC}
make -j${NPROC} install
