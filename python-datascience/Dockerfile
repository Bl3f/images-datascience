ARG BASE_IMAGE=cblefari/onyxia-python-minimal
FROM $BASE_IMAGE

SHELL ["/bin/bash", "-c"]

ARG JULIA_VERSION="1.8.5"
ENV JULIA_VERSION=${JULIA_VERSION}
ENV JULIA_DIR="/opt/julia"
ENV PATH="${JULIA_DIR}/bin:${PATH}"

USER root

COPY conda-env.yml .

RUN ls -larth /opt/
RUN mamba env update -n base -f conda-env.yml && \
    # Install Julia
    /opt/install-julia.sh && \
    # Install Quarto latest version
    /opt/install-quarto.sh && \
    # Fix permissions
    chown -R ${USERNAME}:${GROUPNAME} ${HOME} ${MAMBA_DIR} ${JULIA_DIR} && \
    # Clean
    rm conda-env.yml && \ 
    mamba clean --all -f -y && \
    rm -rf /var/lib/apt/lists/*

USER 1000

CMD ["python3"]
