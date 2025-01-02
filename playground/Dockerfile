# USER HOME
ARG PLAYER_HOME=/home/player
# VERSIONS
## RUST
ARG CARGO_WATCH_VERSION=8.5.3
ARG RUST_VERSION=1.83.0
ARG STARSHIP_PRESET=plain-text-symbols
ARG STARSHIP_VERSION=1.20.1
## PYTHON
ARG PIPX_VERSION=1.7.1
ARG PRE_COMMIT_VERSION=3.8.0
ARG PYTHON_VERSION=3.10.14
ARG TYPER_VERSION=0.12.5
ARG UV_VERSION=0.4.7
## NODE
ARG NODE_VERSION=20.17.0
ARG NVM_VERSION=0.40.1
## GOLANG
ARG GO_VERSION=1.23.4
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
ARG UV=${LOCAL_BIN}/uv

FROM debian:12 AS build

RUN apt install --yes curl

# GOLANG
FROM golang:${GO_VERSION} AS golang

# STARSHIP
FROM build AS starship

ARG STARSHIP_VERSION

RUN curl -sS https://starship.rs/install.sh \
    | sh -s -- \
    --version ${STARSHIP_VERSION} \
    --bin-dir /root/.local/bin \
    --yes

RUN ls -la /root/.local/bin

# UV
FROM build AS uv

ARG UV_VERSION

RUN curl -LsSf https://astral.sh/uv/install.sh \
    | sh -s -- \
    --version ${UV_VERSION}


# FINAL STAGE
FROM debian:12-slim AS playground

ARG PLAYER_HOME
ARG BASH_ALIASES
ARG LOCAL_BIN
ARG STARSHIP
ARG STARSHIP_PRESET
ARG RUSTUP
ARG CARGO_BIN

# APT
RUN apt update && apt install --yes \
    pipx

# CREATE NEW USER
RUN useradd -ms /bin/bash player
WORKDIR ${PLAYER_HOME}
USER player

# CREATE DIRECTORIES
RUN mkdir --parents \
    ${LOCAL_BIN} \
    ${PLAYER_HOME}/.config \
    ${PLAYER_HOME}/repos \
    ${PLAYER_HOME}/tmp


# CREATE FILES
RUN touch \
    ${BASH_ALIASES}


# INSTALL RUST
RUN curl \
    --proto '=https' \
    --tlsv1.2 \
    -sSf https://sh.rustup.rs/ \
    | sh -s -- \
    -y \
    --default-toolchain=${RUST_VERSION}

#RUN ${RUSTUP} component add clippy


# COPY FROM OTHER STAGES
## GOLANG
COPY --from=golang /usr/local/go/bin/go ${LOCAL_BIN}
COPY --from=golang /usr/local/go/bin/gofmt ${LOCAL_BIN}
## STARSHIP
COPY --from=starship /root/.local/bin/startship ${LOCAL_BIN}




# FINALL STAGE / CONFIGURATION
## BASH_ALIASES
### COMMON ALIASES
RUN echo 'alias ll="ls -la"' >> ${BASH_ALIASES}
RUN echo 'export PATH="$PATH:$HOME/.local/bin"' >> ${BASH_ALIASES}
### CARGO
RUN echo '. "$HOME/.cargo/env"' >> ${BASH_ALIASES}


ENTRYPOINT ["/bin/bash"]
