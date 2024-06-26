ARG BASE_IMAGE=cblefari/onyxia-python-datascience
FROM $BASE_IMAGE

SHELL ["/bin/bash", "-c"]

ARG USER_CONFIG_DIR="${HOME}/.local/share/code-server/User"
ARG REMOTE_CONFIG_DIR="${HOME}/.local/share/code-server/Machine"

USER root

RUN curl -fsSL https://code-server.dev/install.sh | bash && \
    # Install general VSCode extensions
    wget https://github.com/Venthe/vscode-fauxpilot/releases/download/1.0.0/fauxpilot-1.0.0.vsix -O fauxpilot.vsix && \
    code-server --install-extension fauxpilot.vsix && \
    code-server --install-extension ms-toolsai.jupyter && \
    code-server --install-extension ms-kubernetes-tools.vscode-kubernetes-tools && \
    code-server --install-extension ms-azuretools.vscode-docker && \
    code-server --install-extension njpwerner.autodocstring && \
    code-server --install-extension redhat.vscode-yaml && \
    code-server --install-extension mhutchie.git-graph && \
    # Install language specific VSCode extensions
    if command -v python; then \
        code-server --install-extension ms-python.python; \
    fi && \
    if command -v R; then \
        code-server --install-extension reditorsupport.r && \
        R -e "install.packages('languageserver')"; \
    fi && \
    if command -v julia; then \
        code-server --install-extension julialang.language-julia; \
    fi && \
    if command -v quarto; then \
        code-server --install-extension quarto.quarto; \
    fi && \
    # Create directories to store custom VSCode settings
    mkdir -p ${USER_CONFIG_DIR} ${REMOTE_CONFIG_DIR} && \
    # Set Conda binary path in remote settings to auto activate base env when running Python code
    echo "{\"python.condaPath\": \"${MAMBA_DIR}/bin/conda\"}" > ${REMOTE_CONFIG_DIR}/settings.json && \
    # Fix permissions
    chown -R ${USERNAME}:${GROUPNAME} ${HOME} && \
    # Clean
    rm -rf /var/lib/apt/lists/* && \
    rm fauxpilot.vsix

# Copy custom VSCode User settings
COPY --chown=${USERNAME}:${GROUPNAME} settings/User.json ${USER_CONFIG_DIR}/settings.json

RUN apt-get update -y
RUN apt-get install -y python3 python3-pip supervisor
RUN apt-get clean

COPY proxy.py /opt/proxy.py
COPY supervisord.ini /etc/supervisor/conf.d/supervisord.ini

EXPOSE 5000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.ini"]
