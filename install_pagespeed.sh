 yum -y install gcc-c++ pcre-devel pcre-devel zlib-devel make unzip openssl-devel wget
 mkdir -p /opt/nginx/modules
 
 cd /opt/nginx/modules
 wget https://github.com/pagespeed/ngx_pagespeed/archive/release-1.9.32.1-beta.zip
 unzip release-1.9.32.1-beta.zip
 
 cd ngx_pagespeed-release-1.9.32.1-beta/
 wget https://dl.google.com/dl/page-speed/psol/1.9.32.1.tar.gz
 tar -xzf 1.9.32.1.tar.gz

 cd /opt/nginx/
 wget http://nginx.org/download/nginx-1.7.6.tar.gz
 tar -zxf nginx-1.7.6.tar.gz
 cd nginx-1.7.6/
 ./configure --add-module=/opt/nginx/modules/ngx_pagespeed-release-1.9.32.1-beta \
--prefix=/usr/local/nginx \
--sbin-path=/usr/local/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/run/nginx.pid \
--lock-path=/run/lock/subsys/nginx \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--user=nginx \
--group=nginx
make
make install
