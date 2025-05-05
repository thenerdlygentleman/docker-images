# VERSIONS
## CODE_SERVER
ARG CODE_SERVER_VER=4.99.0
## PYTHON
ARG UV_VER=0.6.16
ARG PYTHON_VER=3.10.14
## GO
ARG GO_VERSION=1.23.4
## NODE
ARG NODE_VER=20.17.0
## STARSHIP
ARG STARSHIP_VER=1.21.1
## RUST
ARG RUST_VER=1.83.0
ARG CARGO_WATCH_VER=8.5.3
ARG JUST_VER=1.40.0

# PATHS
## HOME
ARG HOME=/config
ARG BASHRC=${HOME}/.bashrc
ARG LOCAL_CONFIG=${HOME}/.config
ARG LOCAL_BIN=${HOME}/.local/bin
## USR
ARG USR_LOCAL=/usr/local
ARG USR_LOCAL_BIN=${USR_LOCAL}/bin
ARG USR_LOCAL_LIB=${USR_LOCAL}/lib
## CODE_SERVER
ARG CODE_SERVER_BIN=/app/code-server/bin/code-server
## GO
ARG GO_DIR=${USR_LOCAL}/go
## NODE
ARG NODE_BIN=${USR_LOCAL_BIN}/node
ARG NPM_BIN=${USR_LOCAL_BIN}/npm
ARG NPX_BIN=${USR_LOCAL_BIN}/npx
ARG NODE_MODULES=${USR_LOCAL_LIB}/node_modules
ARG NODE_MODULES_BIN=${NODE_MODULES}/npm/bin
## RUST
ARG CARGO_BIN=${USR_LOCAL}/cargo/bin
ARG CARGO_DIR=${HOME}/.cargo
ARG RUSTUP_DIR=${HOME}/.rustup

# BUILD TARGETS
## UV
FROM ghcr.io/astral-sh/uv:${UV_VER} AS uv

## GO
FROM golang:${GO_VERSION} AS go

## NODE
FROM node:${NODE_VER} AS node

## CARGO
FROM rust:slim AS cargo
ARG CARGO_WATCH_VER
ARG JUST_VER
RUN cargo install cargo-watch@${CARGO_WATCH_VER} just@${JUST_VER}

## BASE
FROM debian:12-slim AS build
RUN apt update && apt install --yes curl wget tar

## STARSHIP
FROM build AS starship
ARG STARSHIP_VER
RUN curl -sS https://starship.rs/install.sh \
    | sh -s -- \
    --yes \
    --bin-dir /root \
    --version v${STARSHIP_VER}

## RUST
FROM build AS rust
ARG RUST_VER
RUN curl \
    --proto '=https' \
    --tlsv1.2 \
    -sSf https://sh.rustup.rs \
    | sh -s -- \
    -y \
    --default-toolchain=${RUST_VER}

# RELEASE
FROM lscr.io/linuxserver/code-server:${CODE_SERVER_VER} AS playground

## ARGUMENTS
ARG BASHRC
ARG CARGO_BIN
ARG CARGO_DIR
ARG CODE_SERVER_BIN
ARG GO_DIR
ARG HOME
ARG LOCAL_BIN
ARG LOCAL_CONFIG
ARG NODE_BIN
ARG NODE_MODULES
ARG NODE_MODULES_BIN
ARG NPM_BIN
ARG NPX_BIN
ARG PYTHON_VER
ARG RUSTUP_DIR
ARG USR_LOCAL_BIN

# APT
RUN apt update && apt install --yes gcc

## CODE_SERVER
RUN for extension in \
    bierner.markdown-mermaid \
    charliermarsh.ruff \
    d-biehl.robotcode \
    golang.go \
    ms-playwright.playwright \
    ms-python.python \
    ms-vscode.live-server \
    nefrob.vscode-just-syntax \
    rust-lang.rust-analyzer \
    streetsidesoftware.code-spell-checker \
    tamasfe.even-better-toml \
    vscode-icons-team.vscode-icons; do \
    ${CODE_SERVER_BIN} \
    --extensions-dir /config/extensions \
    --force \
    --install-extension \
    $extension; done

## DIRECTORIES
RUN mkdir --parents \
    ${LOCAL_BIN} \
    ${LOCAL_CONFIG}

## UV
COPY --from=uv /uv /uvx ${USR_LOCAL_BIN}/
RUN uv python install ${PYTHON_VER}

## GO
COPY --from=go ${GO_DIR} ${GO_DIR}

## NODE
COPY --from=node ${NODE_BIN} ${NPM_BIN} ${NPX_BIN} ${USR_LOCAL_BIN}/
COPY --from=node ${NODE_MODULES} ${NODE_MODULES}
RUN ln -sf ${NODE_MODULES_BIN}/npm-cli.js ${NPM_BIN} && \
    ln -sf ${NODE_MODULES_BIN}/npx-cli.js ${NPX_BIN}

## STARSHIP
COPY --from=starship /root/starship ${USR_LOCAL_BIN}/

## RUST
COPY --from=rust /root/.cargo ${CARGO_DIR}
COPY --from=rust /root/.rustup ${RUSTUP_DIR}
COPY --from=cargo ${CARGO_BIN}/* ${USR_LOCAL_BIN}/
ENV CARGO_HOME=${CARGO_DIR}
ENV RUSTUP_HOME=${RUSTUP_DIR}

## FILES
COPY config/starship.toml ${LOCAL_CONFIG}/starship.toml
COPY config/vsc-settings.json ${HOME}/data/User/settings.json
COPY config/.bashrc ${HOME}/.bashrc

## PATH
ENV PATH="$PATH:${USR_LOCAL_BIN}:${CARGO_DIR}/bin:${GO_DIR}/bin:${LOCAL_BIN}"

# TEST
FROM playground AS test

ARG HOME
ARG TEST_DIR=${HOME}/test-dir
RUN mkdir -p ${TEST_DIR}

# CLIENTS
RUN starship --help
RUN cargo-watch --help
RUN just --help

## PYTHON
RUN mkdir ${TEST_DIR}/python-test
WORKDIR ${TEST_DIR}/python-test
RUN uv init
RUN uv run main.py
RUN uv add typer
RUN uvx cowsay -t foobar

## RUST
RUN mkdir ${TEST_DIR}/rust-test
WORKDIR ${TEST_DIR}/rust-test
RUN cargo init
RUN cargo run
RUN cargo add evdev

## GO
RUN mkdir ${TEST_DIR}/go-test
WORKDIR ${TEST_DIR}/go-test
RUN go mod init hello
RUN echo 'package main; import ("fmt"); func main() { fmt.Println("Hello World!");}' \
    > main.go
RUN go run main.go
RUN go get github.com/mattn/go-sqlite3
RUN gofmt -w main.go

## NODE
RUN mkdir ${TEST_DIR}/node-test
WORKDIR ${TEST_DIR}/node-test
RUN touch main.js
RUN echo 'console.log("Hello World!");' > main.js
RUN node main.js
RUN npm install playwright
