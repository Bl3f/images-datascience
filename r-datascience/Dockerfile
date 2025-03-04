ARG BASE_IMAGE=cblefari/onyxia-r-minimal
FROM $BASE_IMAGE

SHELL ["/bin/bash", "-c"]

USER root

# Mettre à jour les paquets et installer les dépendances système
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        language-pack-fr \
        libsecret-1-dev

# Installer Quarto
RUN /opt/install-quarto.sh

# Installer Shiny Server
RUN /rocker_scripts/install_shiny_server.sh

# Installer les bundles de packages Rocker
RUN /rocker_scripts/install_tidyverse.sh

RUN /rocker_scripts/install_verse.sh

RUN /rocker_scripts/install_geospatial.sh

# Réinstaller les librairies système qui pourraient avoir été supprimées par autoremove dans les scripts Rocker
RUN /opt/install-system-libs.sh

# Installer des packages R supplémentaires
RUN install2.r -e -s \
        keyring \
        odbc \
        quarto \
        Rglpk \
        RJDemetra \
        RPostgreSQL \
        RSQLite \
        job \
        writexl \
        kableExtra \
        rdd \
        ggtext \
        magick \
        plm \
        lmtest \
        AER \
        ivpack \
        fastDummies \
        causalTree \
        plyr \
        tidyverse \
        tidyr \
        dplyr \
        ggplot2 \
        plm \
        stargazer \
        stringr \
        fixest \
        ggeffects \
        knitr \
        janitor \
        haven \
        targets

# Installer gouvdown
RUN --mount=type=secret,id=github_token \
    export GITHUB_PAT=`cat /run/secrets/github_token` && \
    installGithub.r spyrales/gouvdown && \
    installGithub.r spyrales/gouvdown.fonts && \
    find /usr/local/lib/R/site-library/gouvdown.fonts -name "*.ttf" -exec cp '{}' /usr/local/share/fonts \; && \
    fc-cache && \
    R -e "gouvdown::check_fonts_in_r()"

# Corriger les permissions
RUN chown -R ${USERNAME}:${GROUPNAME} ${HOME} ${R_HOME}

RUN rm -rf /var/lib/apt/lists/*

USER 1000

CMD ["R"]
