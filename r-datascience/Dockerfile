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

#Ne fonctionne plus, il faut passer en 4.2.3
RUN /rocker_scripts/install_verse.sh

#COPY install_verse.sh /opt/install_verse.sh
#RUN chmod +x /opt/install_verse.sh
#RUN /opt/install_verse.sh

RUN /rocker_scripts/install_geospatial.sh

# Réinstaller les librairies système qui pourraient avoir été supprimées par autoremove dans les scripts Rocker
RUN /opt/install-system-libs.sh

# Installer des packages R supplémentaires
RUN install2.r -e -s keyring 
RUN install2.r -e -s odbc
RUN install2.r -e -s quarto
RUN install2.r -e -s Rglpk
RUN install2.r -e -s RJDemetra
RUN install2.r -e -s RPostgreSQL
RUN install2.r -e -s RSQLite
RUN install2.r -e -s job
RUN install2.r -e -s writexl
RUN install2.r -e -s kableExtra
# Ne fonctionne pas avec la version actuel
#RUN install2.r -e -s rdd
RUN install2.r -e -s ggtext
RUN install2.r -e -s magick
RUN install2.r -e -s plm
RUN install2.r -e -s lmtest
# Ne fonctionne pas
#RUN install2.r -e -s AER
#RUN install2.r -e -s ivpack
RUN install2.r -e -s fastDummies
#RUN install2.r -e -s causalTree
RUN install2.r -e -s plyr
RUN install2.r -e -s tidyverse
RUN install2.r -e -s tidyr
RUN install2.r -e -s dplyr
RUN install2.r -e -s ggplot2
RUN install2.r -e -s stargazer
RUN install2.r -e -s stringr
RUN install2.r -e -s fixest
RUN install2.r -e -s ggeffects
RUN install2.r -e -s knitr
RUN install2.r -e -s janitor
RUN install2.r -e -s haven
RUN install2.r -e -s targets

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
