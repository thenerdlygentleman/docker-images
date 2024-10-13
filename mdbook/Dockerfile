FROM rust:1.81-slim AS mdbook

# VERSION
ARG MDBOOK_MERMAID=0.14.0
ARG MDBOOK_VARIABLES=0.2.4
ARG MDBOOK=0.4.40

RUN cargo install \
    mdbook-mermaid@${MDBOOK_MERMAID} \
    mdbook-variables@${MDBOOK_VARIABLES} \
    mdbook@${MDBOOK}
