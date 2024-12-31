# INSTALL GO
# Go can only be build from source if, there is already a go compiler installed
# Downloading the binary is an option, but makes the Dockerfile complicated
# if you want to use it for multiple architectures.
FROM golang:1.23.4 AS golang


FROM ubuntu:22.04


# USER HOME
ARG PLAYER_HOME=/home/player
# TOOLS VERSIONS
ARG CARGO_WATCH=8.5.3
ARG GLAB_VERSION=1.46.1
ARG GO_VERSION=go1.23.4
ARG NODE_VERSION=20.17.0
ARG NVM_VERSION=0.40.1
ARG PIPX_VERSION=1.7.1
ARG PRE_COMMIT_VERSION=3.8.0
ARG PYTHON_VERSION=3.10.14
ARG RUST_VERSION=1.81.0
ARG STARSHIP_PRESET=plain-text-symbols
ARG STARSHIP_VERSION=1.20.1
ARG TYPER_VERSION=0.12.5
ARG UV_VERSION=0.4.7
# PATHS
##
ARG LOCAL_BIN=${PLAYER_HOME}/.local/bin
## BASH
ARG BASH_ALIASES=${PLAYER_HOME}/.bash_aliases
## CARGO
ARG CARGO_DIRECTORY=${PLAYER_HOME}/.cargo
ARG CARGO_BIN=${CARGO_DIRECTORY}/bin
## NVM
ARG NVM_DIRECTORY=${PLAYER_HOME}/.nvm
## GOLANG
ARG GO_DIRECTORY=${PLAYER_HOME}/goroot
ARG GO_BIN=${GO_DIRECTORY}/bin
## BINARIES
ARG CARGO=${CARGO_BIN}/cargo
ARG RUSTUP=${CARGO_BIN}/rustup
ARG STARSHIP=${CARGO_BIN}/starship
ARG PIPX=/usr/bin/pipx
ARG UV=${LOCAL_BIN}/uv


# CREATE NEW USER
RUN useradd -ms /bin/bash player
WORKDIR ${PLAYER_HOME}


# INSTALL APT PACKAGES
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt update && apt install --yes \
    cmake \
    curl \
    fontconfig \
    gcc \
    git \
    nano \
    pipx \
    wget \
    zip


# ACTIVATE USER
USER player

# CREATE DIRECTORIES
RUN mkdir --parents \
    ${PLAYER_HOME}/.config \
    ${PLAYER_HOME}/repos \
    ${PLAYER_HOME}/tmp


# CREATE FILES
RUN touch \
    ${BASH_ALIASES}


# INSTALL RUST
## INSTALL
RUN curl \
    --proto '=https' \
    --tlsv1.2 \
    -sSf https://sh.rustup.rs/ \
    | sh -s -- \
    -y \
    --default-toolchain=${RUST_VERSION}
## EDIT BASH_ALIASES
RUN echo '. "$HOME/.cargo/env"' >> ${BASH_ALIASES}
## INSTALL CARGO PACKAGES
RUN ${CARGO} install cargo-watch@${CARGO_WATCH}
## ADD RUSTUP COMPONENTS
RUN ${RUSTUP} component add clippy


# INSTALL PIPX
## EDIT BASH_ALIASES
#RUN echo 'eval "$(register-python-argcomplete pipx)"' >> ${BASH_ALIASES}
## INSTALL PACKAGES
RUN ${PIPX} ensurepath
RUN ${PIPX} install uv==${UV_VERSION}
RUN ${PIPX} install pre-commit==${PRE_COMMIT_VERSION}
RUN ${PIPX} install typer==${TYPER_VERSION}


# INSTALL PYTHON VERSION
RUN ${UV} python install ${PYTHON_VERSION}


# INSTALL NODE
## INSTALLATION
RUN curl -o- \
    https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh \
    | bash
USER root
RUN . ${NVM_DIRECTORY}/nvm.sh && \
    nvm install ${NODE_VERSION}
USER player
## EDIT BASH_ALIASES
RUN echo 'NVM_DIRECTORY="$HOME/.nvm"' >> ${BASH_ALIASES}
RUN echo 'if [ -d "$NVM_DIRECTORY" ]; then \
    export NVM_DIR="$NVM_DIRECTORY"; \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"; fi' \
    >> ${BASH_ALIASES}


# INSTALL GITHUB CLIENT
#USER root
#RUN mkdir -p -m 755 /etc/apt/keyrings && \
#    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
#    | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null &&\
#    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&\
#    echo "deb [arch=$(dpkg --print-architecture) \
#    signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] \
#    https://cli.github.com/packages stable main" \
#    | tee /etc/apt/sources.list.d/github-cli.list > /dev/null &&\
#    apt update &&\
#    apt install gh -y
#USER player


# INSTALL GITLAB CLIENT
# Deactivating it at the moment, because the installation is only for x86.
# TODO find a better way to install this.
#ARG GLAB_DEB=glab_${GLAB_VERSION}_Linux_x86_64.deb
#RUN wget -P ${PLAYER_HOME}/tmp \
#    https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/${GLAB_DEB}
#USER root
#RUN apt install ${PLAYER_HOME}/tmp/${GLAB_DEB}
#USER player


# INSTALL STARTSHIP
RUN curl -sS https://starship.rs/install.sh \
    | sh -s -- \
    --bin-dir ${CARGO_BIN} \
    --yes
RUN touch ${PLAYER_HOME}/.config/startship.toml
RUN ${STARSHIP} \
    preset ${STARSHIP_PRESET} \
    -o ${PLAYER_HOME}/.config/starship.toml

# Following code install the GeistMono font. Is not necessary, because the
# host machine does need to install the font.
#RUN mkdir ${PLAYER_HOME}/.fonts
#RUN wget -P ${PLAYER_HOME}/.fonts \
#    https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/GeistMono.zip
#RUN cd ${PLAYER_HOME}/.fonts && \
#    unzip ${PLAYER_HOME}/.fonts/GeistMono.zip && \
#    cd ${PLAYER_HOME}
#RUN fc-cache -fv


# COPY GOLANG
COPY --from=golang /usr/local/go/bin/* ${LOCAL_BIN}


## EDIT BASH_ALIASES
RUN echo 'eval "$(/home/player/.cargo/bin/starship init bash)"' >> ${BASH_ALIASES}
RUN echo 'export PATH="$PATH:$HOME/.local/bin"' >> ${BASH_ALIASES}


ENTRYPOINT ["/bin/bash"]
