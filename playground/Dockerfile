##########      VERSIONS        ##########
ARG GO_VERSION=1.23.4
ARG CARGO_WATCH_VERSION=8.5.3
ARG UV_VERSION=0.5.14
ARG PYTHON_VERSION=3.10.14
ARG RUST_VERSION=1.83.0
ARG NODE_VERSION=20.17.0
ARG NVM_VERSION=0.40.1

##########      PATHS           ##########
ARG PLAYER_HOME=/home/player
ARG BASH_ALIASES=${PLAYER_HOME}/.bash_aliases
ARG LOCAL_BIN=${PLAYER_HOME}/.local/bin
ARG CARGO_DIRECTORY=${PLAYER_HOME}/.cargo
ARG CARGO_BIN=${CARGO_DIRECTORY}/bin
ARG NVM_DIRECTORY=${PLAYER_HOME}/.nvm
ARG RUSTUP_DIRECTORY=${PLAYER_HOME}/.rustup

##########      CARGO BINARIES  ##########
FROM rust:${RUST_VERSION} AS cargo
ARG CARGO_WATCH_VERSION
RUN cargo install cargo-watch@${CARGO_WATCH_VERSION}

##########      Build           ##########
FROM debian:12 AS build
RUN apt update && apt install --yes curl

##########      STARSHIP        ##########
FROM build AS starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir /root

##########      UV              ##########
FROM build AS uv
ARG UV_VERSION
RUN curl -LsSf https://astral.sh/uv/${UV_VERSION}/install.sh | sh

##########      RUST            ##########
FROM build AS rust
ARG RUST_VERSION
RUN curl \
    --proto '=https' \
    --tlsv1.2 \
    -sSf https://sh.rustup.rs \
    | sh -s -- \
    -y \
    --default-toolchain=${RUST_VERSION}

##########      NODE            ##########
FROM build AS node
ARG NODE_VERSION
ARG NVM_VERSION
RUN curl -o- \
    https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh \
    | bash
RUN . /root/.nvm/nvm.sh && \
    nvm install ${NODE_VERSION}

##########      BASE            ##########
FROM debian:12-slim AS base

# ARGUMENTS
ARG PLAYER_HOME
ARG BASH_ALIASES
ARG LOCAL_BIN
ARG PYTHON_VERSION
ARG RUST_VERSION
ARG CARGO_DIRECTORY
ARG CARGO_BIN
ARG GO_VERSION
ARG NVM_DIRECTORY
ARG RUSTUP_DIRECTORY

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
    ${LOCAL_BIN} \
    ${CARGO_BIN}

# CREATE FILES
RUN touch \
    ${BASH_ALIASES}

# COPY FILES FROM OTHER IMAGES
COPY --from=starship /root/starship ${LOCAL_BIN}
COPY --from=uv /root/.local/bin/uv ${LOCAL_BIN}
COPY --from=uv /root/.local/bin/uvx ${LOCAL_BIN}
COPY --from=rust /root/.cargo ${CARGO_DIRECTORY}
COPY --from=rust /root/.rustup ${RUSTUP_DIRECTORY}
COPY --from=node /root/.nvm ${NVM_DIRECTORY}
COPY --from=cargo /usr/local/cargo/bin/cargo-watch ${LOCAL_BIN}

# INSTALL PYTHON
RUN ${LOCAL_BIN}/uv python install ${PYTHON_VERSION}

# ADD CLIPPY TO RUSTUP
RUN ${CARGO_BIN}/rustup component add clippy

# INSTALL GOLANG
# ATM this image is created for amd64 and arm64. If you want to include more
# architectures, you have to add them to the following shell script.
#RUN \
#    if [ $(uname -m) = "x86_64" ]; then \
#        curl -sSfO --output-dir ${PLAYER_HOME} https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz; \
#        ls -la ${PLAYER_HOME}; \
#        tar -C /usr/local -xzf ${PLAYER_HOME}/go${GO_VERSION}.linux-amd64.tar.gz; \
#    elif [ $(uname -m) = "aarch64" ]; then \
#        curl -sSfO --output-dir ${PLAYER_HOME} https://golang.org/dl/go${GO_VERSION}.linux-arm64.tar.gz \
#        |tar -C /usr/local -xzf ${PLAYER_HOME}/go${GO_VERSION}.linux-arm64.tar.gz; \
#    else \
#        echo "Unsupported architecture"; \
#        exit 1; \
#    fi

# EDIT BASH ALIASES
RUN echo 'alias ll="ls -la"' >> ${BASH_ALIASES}
RUN echo 'export PATH="$PATH:$HOME/.local/bin:/usr/local/go/bin"' \
>> ${BASH_ALIASES}
RUN echo '. "$HOME/.cargo/env"' >> ${BASH_ALIASES}
RUN echo 'eval "$(starship init bash)"' >> ${BASH_ALIASES}
RUN echo 'NVM_DIRECTORY="$HOME/.nvm"' >> ${BASH_ALIASES}
RUN echo 'if [ -d "$NVM_DIRECTORY" ]; then \
    export NVM_DIR="$NVM_DIRECTORY"; \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"; fi' \
    >> ${BASH_ALIASES}

##########      TEST            ##########
FROM base AS test

ARG PLAYER_HOME
ARG LOCAL_BIN
ARG CARGO_BIN

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

RUN go --help

##########      FINAL STAGE     ##########
FROM base AS playground
ENTRYPOINT [ "/bin/bash" ]
