ARG MDBOOK_MERMAID=0.14.0
ARG MDBOOK_VARIABLES=0.2.4
ARG MDBOOK=0.4.40

FROM rust:slim AS rust

ARG MDBOOK
ARG MDBOOK_MERMAID
ARG MDBOOK_VARIABLES

RUN cargo install \
    mdbook-mermaid@${MDBOOK_MERMAID} \
    mdbook-variables@${MDBOOK_VARIABLES} \
    mdbook@${MDBOOK}

FROM debian:12-slim AS mdbook

COPY --from=rust \
    /usr/local/cargo/bin/mdbook \
    /usr/local/bin/mdbook
COPY --from=rust \
    /usr/local/cargo/bin/mdbook-mermaid \
    /usr/local/bin/mdbook-mermaid
COPY --from=rust \
    /usr/local/cargo/bin/mdbook-variables \
    /usr/local/bin/mdbook-variables
