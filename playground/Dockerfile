##########      VERSIONS        ##########
ARG GO_VERSION=1.23.4
ARG CARGO_WATCH_VERSION=8.5.3
ARG UV_VERSION=0.5.14
ARG PYTHON_VERSION=3.10.14
ARG RUST_VERSION=1.83.0

##########      PATHS           ##########
# USER
ARG PLAYER_HOME=/home/player
ARG BASH_ALIASES=${PLAYER_HOME}/.bash_aliases
ARG LOCAL_BIN=${PLAYER_HOME}/.local/bin

##########      STARSHIP        ##########
FROM debian:12 AS starship
RUN apt update && apt install --yes curl
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir /root

##########      CARGO BINARIES  ##########
FROM rust:slim AS cargo
ARG CARGO_WATCH_VERSION
RUN cargo install cargo-watch@${CARGO_WATCH_VERSION}

##########      UV              ##########
FROM debian:12 AS uv
ARG UV_VERSION
RUN apt update && apt install --yes curl
RUN curl -LsSf https://astral.sh/uv/${UV_VERSION}/install.sh | sh

##########      BASE            ##########
FROM debian:12-slim AS base

# ARGUMENTS
ARG PLAYER_HOME
ARG BASH_ALIASES
ARG LOCAL_BIN
ARG PYTHON_VERSION
ARG RUST_VERSION

# APT
RUN apt update && apt install --yes \
    curl \
    gcc \
    nano

# CREATE USER
RUN useradd -ms /bin/bash player
WORKDIR ${PLAYER_HOME}
USER player

# CREATE DIRECTORIES
RUN mkdir --parents \
    ${LOCAL_BIN}

# CREATE FILES
RUN touch \
    ${BASH_ALIASES}

# COPY FILES FROM OTHER IMAGES
COPY --from=starship /root/starship ${LOCAL_BIN}
COPY --from=cargo /usr/local/cargo/bin/cargo-watch ${LOCAL_BIN}
COPY --from=uv /root/.local/bin/uv ${LOCAL_BIN}

# INSTALL PYTHON
RUN ${LOCAL_BIN}/uv python install ${PYTHON_VERSION}

# INSTALL RUST
RUN curl \
    --proto '=https' \
    --tlsv1.2 \
    -sSf https://sh.rustup.rs \
    | sh -s -- \
    -y \
    --default-toolchain=${RUST_VERSION}

# EDIT BASH ALIASES
RUN echo 'alias ll="ls -la"' >> ${BASH_ALIASES}
RUN echo 'export PATH="$PATH:$HOME/.local/bin"' >> ${BASH_ALIASES}
RUN echo '. "$HOME/.cargo/env"' >> ${BASH_ALIASES}
RUN echo 'eval "$(starship init bash)"' >> ${BASH_ALIASES}

##########      TEST            ##########
FROM base AS test

ARG PLAYER_HOME
ARG LOCAL_BIN
ARG CARGO_BIN=${PLAYER_HOME}/.cargo/bin

RUN ${LOCAL_BIN}/starship help
RUN ${LOCAL_BIN}/cargo-watch --help

RUN mkdir ${PLAYER_HOME}/python-test
WORKDIR ${PLAYER_HOME}/python-test
RUN ${LOCAL_BIN}/uv init
RUN ${LOCAL_BIN}/uv python --version

RUN mkdir ${PLAYER_HOME}/rust-test
WORKDIR ${PLAYER_HOME}/rust-test
RUN ${CARGO_BIN}/cargo init
RUN ${CARGO_BIN}/cargo run

##########      FINAL STAGE     ##########
FROM base AS playground
ENTRYPOINT [ "/bin/bash" ]
