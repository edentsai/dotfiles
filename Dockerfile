# syntax=docker/dockerfile:1.0-experimental

FROM phusion/baseimage:0.11 AS ubuntu-workspace
SHELL ["/bin/bash", "-o", "xtrace", "-o", "nounset", "-o", "errexit", "-o", "pipefail", "-c"]

ARG VERSION=latest
LABEL maintainer="Eden Tsai <edentsai231@gmail.com>"
LABEL name="edentsai/dotfiles/ubuntu-workspace"
LABEL version="$VERSION"

# Generates and configure localisation
USER root
RUN locale-gen en_US.UTF-8 zh_TW.UTF-8

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm

# Configure Timezone
ARG TIMEZONE=UTC
ENV TZ=$TIMEZONE

# Install packages
USER root
RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update
    # Install man pages
RUN sed \
        -i '/^path-exclude=\/usr\/share\/man\/*/c\# path-exclude=\/usr\/share\/man\/*' \
        /etc/dpkg/dpkg.cfg.d/excludes \
    && apt-get install --yes --no-install-recommends \
        man-db=2.* \
        manpages=4.* \
        manpages-posix=2013a-* \
    && ( \
        set +e; \
        yes | /usr/local/sbin/unminimize; \
        set -e; \
    ) \
    # Install packages
    && apt-get install --yes --no-install-recommends \
        apt-utils=1.* \
        autoconf=2.* \
        automake=1:1.* \
        bash=4.* \
        bd=1.* \
        build-essential=12.* \
        curl=7.* \
        dpkg=1.* \
        exuberant-ctags=1:5.* \
        ffmpeg=7:3.* \
        fontconfig=2.* \
        gettext=0.* \
        gifsicle=1.* \
        git=1:2.* \
        gpg=2.* \
        gzip=1.* \
        imagemagick=8:6.* \
        inetutils-ping=2:1.* \
        jpegoptim=1.* \
        less=487-* \
        libcurl4-openssl-dev=7.* \
        libedit-dev=3.* \
        libevent-dev=2.* \
        libexpat1-dev=2.* \
        libncurses5-dev=6.* \
        libncursesw5-dev=6.* \
        libssh2-1-dev=1.* \
        libssl-dev=1.* \
        libtool=2.* \
        libxml2-dev=2.* \
        libxslt1-dev=1.* \
        libzip-dev=1.* \
        locales=2.* \
        make=4.* \
        most=5.* \
        mysql-client=5.* \
        nasm=2.* \
        openssh-client=1:7* \
        openssl=1.* \
        optipng=0.* \
        parallel=20161222-* \
        pkg-config=0.* \
        pngquant=2.* \
        sed=4.* \
        software-properties-common=0.* \
        sudo=1.* \
        tar=1.* \
        tmux=2.* \
        tree=1.* \
        tzdata=2019b-* \
        unzip=6.* \
        vim=2:8.* \
        wget=1.* \
        xz-utils=5.* \
        zip=3.*
    # && apt-get clean
    # && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    # && rm /var/log/lastlog /var/log/faillog

# Create user
# Only create GID for OS X
ARG OS_TYPE=Linux
ARG OS_TYPE_MAC=Darwin
ARG USER_NAME=user
ARG USER_PASSWORD=$USER_NAME
ARG USER_PUID=1000
ARG USER_PGID=1000
RUN if [ "$OS_TYPE" != "$OS_TYPE_MAC" ] ; then \
        groupadd --gid "$USER_PGID" "$USER_NAME"; \
    fi \
    && useradd \
        --uid "$USER_PUID" \
        --gid "$USER_PGID" \
        --create-home "$USER_NAME" \
        --groups docker_env \
        --groups sudo \
    && usermod --shell /bin/bash "$USER_NAME" \
    && (echo "$USER_NAME:$USER_PASSWORD" | chpasswd)

USER $USER_NAME

CMD ["/bin/bash"]
