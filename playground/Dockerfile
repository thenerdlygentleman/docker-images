##########      VERSIONS        ##########
ARG CARGO_WATCH_VERSION=8.5.3
ARG GO_VERSION=1.23.4
ARG NODE_VERSION=20.17.0
ARG NVM_VERSION=0.40.1
ARG PYTHON_VERSION=3.10.14
ARG RUST_VERSION=1.83.0
ARG STARSHIP_VERSION=1.21.1
ARG UV_VERSION=0.5.14

##########      PATHS           ##########
# PLAYER
ARG PLAYER_HOME=/home/player
ARG BASH_ALIASES=${PLAYER_HOME}/.bash_aliases
ARG LOCAL_BIN=${PLAYER_HOME}/.local/bin
ARG LOCAL_CONFIG=${PLAYER_HOME}/.config
ARG LOCAL_TMP=${PLAYER_HOME}/.tmp
# RUST
ARG CARGO_DIRECTORY=${PLAYER_HOME}/.cargo
ARG CARGO_BIN=${CARGO_DIRECTORY}/bin
ARG RUSTUP_DIRECTORY=${PLAYER_HOME}/.rustup
ARG STARSHIP_TOML=${PLAYER_HOME}/.config/starship.toml
# NODE
ARG NVM_DIRECTORY=${PLAYER_HOME}/.nvm
# GO
ARG GO_DIRECTORY=/usr/local/go

##########      CONFIG          ##########
ARG STARSHIP_PRESET=plain-text-symbols

##########      CARGO BINARIES  ##########
FROM rust:slim AS cargo
ARG CARGO_WATCH_VERSION
RUN cargo install cargo-watch@${CARGO_WATCH_VERSION}

##########      Build           ##########
FROM debian:12-slim AS build
RUN apt update && apt install --yes curl wget tar

##########      STARSHIP        ##########
FROM build AS starship
ARG STARSHIP_VERSION
RUN curl -sS https://starship.rs/install.sh \
    | sh -s -- \
    --yes \
    --bin-dir /root \
    --version v${STARSHIP_VERSION}

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

##########      GO              ##########
FROM build AS go
ARG GO_VERSION
# If you want to include more architectures, you have to add them to the
# following shell script.
RUN \
    if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then \
        wget -P /root https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz; \
        tar -C /usr/local -xzf /root/go${GO_VERSION}.linux-amd64.tar.gz; \
    elif [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ]; then \
        wget -P /root https://golang.org/dl/go${GO_VERSION}.linux-arm64.tar.gz; \
        tar -C /usr/local -xzf /root/go${GO_VERSION}.linux-arm64.tar.gz; \
    else \
        echo "Unsupported architecture"; \
        exit 1; \
    fi

##########      BASE            ##########
FROM debian:12-slim AS base

# ARGUMENTS
ARG BASH_ALIASES
ARG CARGO_BIN
ARG CARGO_DIRECTORY
ARG GO_DIRECTORY
ARG GO_VERSION
ARG LOCAL_BIN
ARG LOCAL_CONFIG
ARG LOCAL_TMP
ARG NVM_DIRECTORY
ARG PLAYER_HOME
ARG PYTHON_VERSION
ARG RUST_VERSION
ARG RUSTUP_DIRECTORY
ARG STARSHIP_PRESET
ARG STARSHIP_TOML

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
    ${CARGO_BIN} \
    ${LOCAL_BIN} \
    ${LOCAL_CONFIG} \
    ${LOCAL_TMP}

# CREATE FILES
RUN touch \
    ${BASH_ALIASES} \
    ${STARSHIP_TOML}

# COPY FILES FROM OTHER IMAGES
COPY --from=starship /root/starship ${LOCAL_BIN}
COPY --from=uv /root/.local/bin/uv ${LOCAL_BIN}
COPY --from=uv /root/.local/bin/uvx ${LOCAL_BIN}
COPY --from=rust /root/.cargo ${CARGO_DIRECTORY}
COPY --from=rust /root/.rustup ${RUSTUP_DIRECTORY}
COPY --from=node /root/.nvm ${NVM_DIRECTORY}
COPY --from=go /usr/local/go ${GO_DIRECTORY}
COPY --from=cargo /usr/local/cargo/bin/cargo-watch ${LOCAL_BIN}

# INSTALL PYTHON
RUN ${LOCAL_BIN}/uv python install ${PYTHON_VERSION}

# ADD CLIPPY TO RUSTUP
RUN ${CARGO_BIN}/rustup component add clippy

# EDIT STARSHIP CONFIG
RUN ${LOCAL_BIN}/starship preset ${STARSHIP_PRESET} -o ${STARSHIP_TOML}

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

ARG CARGO_BIN
ARG GO_DIRECTORY
ARG LOCAL_BIN
ARG NODE_VERSION
ARG NVM_DIRECTORY
ARG PLAYER_HOME

RUN ${LOCAL_BIN}/starship help
RUN ${LOCAL_BIN}/cargo-watch --help

# PYTHON
RUN mkdir ${PLAYER_HOME}/python-test
WORKDIR ${PLAYER_HOME}/python-test
RUN ${LOCAL_BIN}/uv init
RUN ${LOCAL_BIN}/uv run hello.py
RUN ${LOCAL_BIN}/uv add typer

# RUST
RUN mkdir ${PLAYER_HOME}/rust-test
WORKDIR ${PLAYER_HOME}/rust-test
RUN ${CARGO_BIN}/cargo init
RUN ${CARGO_BIN}/cargo run
RUN ${CARGO_BIN}/cargo add evdev

# GO
RUN mkdir ${PLAYER_HOME}/go-test
WORKDIR ${PLAYER_HOME}/go-test
RUN ${GO_DIRECTORY}/bin/go mod init hello
RUN echo 'package main; import ("fmt"); func main() { fmt.Println("Hello World!");}' \
    > main.go
RUN ls -la
RUN ${GO_DIRECTORY}/bin/go run ./main.go
RUN ${GO_DIRECTORY}/bin/go get github.com/mattn/go-sqlite3

# NODE
RUN mkdir ${PLAYER_HOME}/node-test
WORKDIR ${PLAYER_HOME}/node-test
RUN touch main.js
RUN echo 'console.log("Hello World!");' > main.js
RUN ${NVM_DIRECTORY}/versions/node/v${NODE_VERSION}/bin/node ./main.js

##########      FINAL STAGE     ##########
FROM base AS playground
ENTRYPOINT [ "/bin/bash" ]
