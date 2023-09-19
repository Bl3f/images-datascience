ARG BASE_IMAGE=openresty/openresty:alpine-fat
FROM $BASE_IMAGE

RUN mkdir /var/log/nginx

RUN apk add --no-cache openssl-dev
RUN apk add --no-cache git
RUN apk add --no-cache gcc
RUN luarocks install lua-resty-openidc

COPY conf.d/default.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT ["/usr/local/openresty/nginx/sbin/nginx", "-g", "daemon off;"]
EXPOSE 80
