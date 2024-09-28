FROM ubuntu:22.04


# User home
ARG PLAYER_HOME=/home/player


# Tools versions
ARG NODE_VERSION=20.17.0
ARG NVM_VERSION=0.40.1
ARG PIPX_VERSION=1.7.1
ARG PRE_COMMIT_VERSION=3.8.0
ARG PYTHON_VERSION=3.10.14
ARG RUST_VERSION=1.81.0
ARG STARSHIP_VERSION=1.20.1
ARG TYPER_VERSION=0.12.5
ARG UV_VERSION=0.4.7
ARG GLAB_VERSION=1.46.1

# Paths
## Cargo
ARG CARGO_HOME=${PLAYER_HOME}/.cargo
ARG CARGO_BIN=${CARGO_HOME}/bin
# NVM
ARG NVM_DIRECTORY=${PLAYER_HOME}/.nvm


# Binaries
ARG CARGO=${CARGO_BIN}/cargo
ARG STARSHIP=${CARGO_BIN}/starship
ARG PIPX=/usr/bin/pipx
ARG UV=${PLAYER_HOME}/.local/bin/uv


# Create new user
RUN useradd -ms /bin/bash player
WORKDIR ${PLAYER_HOME}

# Install APT packages
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt update && apt install -y \
    cmake \
    curl \
    fontconfig \
    gcc \
    git \
    nano \
    pipx \
    wget \
    zip


# Activate user
USER player


# Create Directories
RUN mkdir \
    ${PLAYER_HOME}/.config \
    ${PLAYER_HOME}/repos \
    ${PLAYER_HOME}/tmp


# Rust
RUN curl \
    --proto '=https' \
    --tlsv1.2 \
    -sSf https://sh.rustup.rs/ \
    | sh -s -- \
    -y \
    --default-toolchain=${RUST_VERSION}


# pipx
RUN ${PIPX} ensurepath
RUN ${PIPX} install uv==${UV_VERSION}
RUN ${PIPX} install pre-commit==${PRE_COMMIT_VERSION}
RUN ${PIPX} install typer==${TYPER_VERSION}


# Python
RUN ${UV} python install ${PYTHON_VERSION}


# Node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
USER root
RUN . ${NVM_DIRECTORY}/nvm.sh && \
    nvm install ${NODE_VERSION}
USER player


# GitHub client
USER root
RUN mkdir -p -m 755 /etc/apt/keyrings && \
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null &&\
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&\
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | tee /etc/apt/sources.list.d/github-cli.list > /dev/null &&\
    apt update &&\
    apt install gh -y
USER player


# GitLab client
ARG GLAB_DEB=glab_${GLAB_VERSION}_Linux_x86_64.deb
RUN wget -P ${PLAYER_HOME}/tmp \
    https://gitlab.com/gitlab-org/cli/-/releases/v1.46.1/downloads/${GLAB_DEB}
USER root
RUN apt install ${PLAYER_HOME}/tmp/${GLAB_DEB}
USER player


# Starship
RUN curl -sS https://starship.rs/install.sh \
    | sh -s -- \
    --bin-dir ${CARGO_BIN} \
    --yes
RUN touch ${PLAYER_HOME}/.config/startship.toml
RUN ${STARSHIP} \
    preset bracketed-segments \
    -o ${PLAYER_HOME}/.config/starship.toml
#RUN mkdir ${PLAYER_HOME}/.fonts
#RUN wget -P ${PLAYER_HOME}/.fonts \
#    https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/GeistMono.zip
#RUN cd ${PLAYER_HOME}/.fonts && \
#    unzip ${PLAYER_HOME}/.fonts/GeistMono.zip && \
#    cd ${PLAYER_HOME}
#RUN fc-cache -fv


# Bash config
COPY .bash_aliases .


ENTRYPOINT ["/bin/bash"]
