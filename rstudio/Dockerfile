ARG BASE_IMAGE=cblefari/onyxia-r-datascience
FROM $BASE_IMAGE

SHELL ["/bin/bash", "-c"]

ENV DEFAULT_USER=${USERNAME}
ENV USERID=${UID}
ENV GROUPID=${GID}


ENV PATH="/usr/lib/rstudio-server/bin:$PATH"

ARG RSTUDIO_CONF_FILE="/etc/rstudio/rsession.conf"

USER root
RUN useradd -ms /bin/bash rstudio

# Install Rstudio using rocker's install scripts
RUN /rocker_scripts/install_rstudio.sh && \
    /rocker_scripts/install_pandoc.sh && \
    # Set default working directory for R sessions and R projects
    echo "session-default-working-dir=${WORKSPACE_DIR}" >> ${RSTUDIO_CONF_FILE} && \
    echo "session-default-new-project-dir=${WORKSPACE_DIR}" >> ${RSTUDIO_CONF_FILE} && \
    # Fix permissions
    chown -R ${USERNAME}:${GROUPNAME} ${HOME} && \
    # Clean
    rm -rf /var/lib/apt/lists/*

RUN apt-get update -y
RUN apt-get install -y python3 python3-pip supervisor
RUN apt-get clean

# Installer iptables
RUN apt-get update && \
    apt-get install -y iptables && \
    rm -rf /var/lib/apt/lists/*

# Ajouter un script pour bloquer github.com
RUN echo "#!/bin/sh\n\
ipset create github_blocked hash:net\n\
for ip in $(dig +short github.com api.github.com raw.github.com | grep -v '^;'); do\n\
  ipset add github_blocked $ip\n\
done\n\
iptables -A OUTPUT -p tcp -m set --match-set github_blocked dst -j DROP\n\
iptables -A OUTPUT -p udp -m set --match-set github_blocked dst -j DROP" > /block_github.sh && \
    chmod +x /block_github.sh

# Exécuter le script au démarrage
RUN echo "/block_github.sh" >> /etc/container_environment_init.sh

RUN echo "127.0.0.1 github.com" >> /etc/hosts && \
    echo "127.0.0.1 api.github.com" >> /etc/hosts && \
    echo "127.0.0.1 raw.github.com" >> /etc/hosts

COPY proxy.py /opt/proxy.py
COPY install.sh /opt/install.sh
COPY supervisord.ini /etc/supervisor/conf.d/supervisord.ini

EXPOSE 5000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.ini"]
