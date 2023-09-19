ARG BASE_IMAGE=openresty/openresty:alpine-fat
FROM $BASE_IMAGE

RUN apk add shadow
RUN set -ex && apk --no-cache add sudo


# Setup user & workspace
ENV USERNAME="onyxia"
ENV UID="900"
ENV GROUPNAME="users"
ENV GID="100"
ENV HOME="/home/${USERNAME}"
ENV WORKSPACE_DIR="${HOME}/work"
RUN groupmod -g ${GID} ${GROUPNAME} && \
    # Setup custom user with sudo rights
    useradd ${USERNAME} --uid=${UID} -g ${GROUPNAME} -r --no-log-init --create-home && \
    # Create workspace
    mkdir ${WORKSPACE_DIR}
WORKDIR ${WORKSPACE_DIR}

RUN mkdir /var/log/nginx

RUN apk add --no-cache openssl-dev
RUN apk add --no-cache git
RUN apk add --no-cache gcc
RUN luarocks install lua-resty-openidc

COPY conf.d/default.conf /etc/nginx/conf.d/default.conf

USER 900

ENTRYPOINT ["/usr/local/openresty/nginx/sbin/nginx", "-g", "daemon off;"]
EXPOSE 80
