ARG BASE_IMAGE=cblefari/onyxia-base
FROM $BASE_IMAGE

SHELL ["/bin/bash", "-c"]

# R Config
ARG R_VERSION="4.2.3"
ENV R_VERSION=${R_VERSION}
ENV R_HOME="/usr/local/lib/R"
ENV DEFAULT_USER="${USERNAME}"

USER root

# Install R using rocker's install scripts
RUN git clone --branch R4.2.3 --depth 1 https://github.com/rocker-org/rocker-versioned2.git /tmp/rocker-versioned2 && \
    cp -r /tmp/rocker-versioned2/scripts/ /rocker_scripts/ && \
    chown -R ${USERNAME}:${GROUPNAME} /rocker_scripts/ && \
    chmod -R 700 /rocker_scripts/ && \
    /rocker_scripts/install_R_source.sh

# Use RStudio's package manager to download packages as binaries
ENV CRAN="https://packagemanager.posit.co/cran/__linux__/jammy/latest"

# Set up R (RSPM, OpenBLAS, littler, addtional packages)
RUN /rocker_scripts/setup_R.sh && \
    # Re-install system libs that may have been removed by autoremove in rocker scripts
    /opt/install-system-libs.sh && \
    # Configure R for CUDA if parent image has CUDA
    if ! [[ -z "${CUDA_VERSION}" ]]; then /rocker_scripts/config_R_cuda.sh; fi && \
    # Install useful additional packages
    install2.r --error \
        aws.s3 \
        devtools \
        lintr \
        paws \
        renv \
        styler \
        vaultr && \
    # Fix permissions
    chown -R ${USERNAME}:${GROUPNAME} ${HOME} ${R_HOME} && \
    # Clean
    rm -rf /var/lib/apt/lists/*

USER 1000

CMD ["R"]
