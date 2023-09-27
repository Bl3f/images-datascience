ARG BASE_IMAGE=openresty/openresty:alpine-fat
FROM $BASE_IMAGE

RUN apk add shadow
RUN set -ex && apk --no-cache add sudo

RUN mkdir /var/log/nginx

RUN apk add --no-cache openssl-dev
RUN apk add --no-cache git
RUN apk add --no-cache gcc
RUN luarocks install lua-resty-openidc

COPY conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY run.sh /opt/run.sh

CMD ["bash", "/opt/run.sh"]
EXPOSE 80
