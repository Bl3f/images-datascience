ARG BASE_IMAGE=cblefari/onyxia-python-datascience
FROM $BASE_IMAGE

SHELL ["/bin/bash", "-c"]

USER root

# Install JupyterLab
RUN /opt/install-jupyterlab.sh && \
    # If using Conda and Julia is installed, make its kernel available in Jupyter
    if command -v julia && [ -n "$MAMBA_DIR" ]; then \
        julia -e 'using Pkg; pkg"add IJulia"; pkg"precompile"' && \
        mv "${HOME}/.local/share/jupyter/kernels/julia"* "${MAMBA_DIR}/share/jupyter/kernels/"; \
    fi && \
    # If R is installed, make its kernel available in Jupyter
    if command -v R; then \
        R -e "install.packages('IRkernel'); IRkernel::installspec()"; \
    fi && \
    # Fix permissions
    chown -R ${USERNAME}:${GROUPNAME} ${HOME} ${MAMBA_DIR} && \
    # Clean
    jupyter lab clean && \
    rm -rf /var/lib/apt/lists/* && \
    if command -v mamba; then \
        mamba clean --all -f -y; \
    fi

RUN pip install keycloakauthenticator==3.3.0

COPY awful_override_auth.py /opt/mamba/lib/python3.10/site-packages/keycloakauthenticator/auth.py

COPY --chown=${USERNAME}:${GROUPNAME} config/jupyter_lab_config.py ${HOME}/.jupyter/jupyter_lab_config.py

RUN curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash - && \
    sudo apt-get install -y nodejs && \
    npm install -g configurable-http-proxy

COPY depp/ ${HOME}/depp
RUN pip install ${HOME}/depp

#Add custom script for git
COPY --chown=${USERNAME}:${GROUPNAME} install_git_jupyter.sh ${HOME}/install_git_jupyter.sh
RUN chmod 700 ${HOME}/install_git_jupyter.sh

RUN apt-get update && \
    apt-get install -y iptables && \
    rm -rf /var/lib/apt/lists/*

RUN echo "#!/bin/sh\n\
iptables -A OUTPUT -p tcp -d idees-prod.depp.in.adc.education.fr -j ACCEPT\n\
iptables -A OUTPUT -p tcp -d *.idee-prod.depp.in.adc.education.fr -j ACCEPT\n\
iptables -A OUTPUT -p tcp -j DROP" > /usr/local/bin/configure_iptables.sh && \
    chmod +x /usr/local/bin/configure_iptables.sh

# Exécuter le script au démarrage
RUN echo "/usr/local/bin/configure_iptables.sh" >> /etc/container_environment_init.sh

USER 1000

EXPOSE 8888

CMD ["jupyterhub", "-f", "${HOME}/.jupyter/jupyter_lab_config.py"]