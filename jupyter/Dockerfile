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

USER 1000

EXPOSE 8888

CMD ["jupyterhub", "-f", "${HOME}/.jupyter/jupyter_lab_config.py"]