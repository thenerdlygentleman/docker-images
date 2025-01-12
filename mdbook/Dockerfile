FROM rust:slim AS rust

ARG MDBOOK_MERMAID=0.14.0
ARG MDBOOK_VARIABLES=0.2.4
ARG MDBOOK=0.4.40

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

FROM mdbook AS test
RUN mkdir /root/book-test
WORKDIR /root/book-test
RUN touch book.toml
RUN /usr/local/bin/mdbook help
RUN /usr/local/bin/mdbook-mermaid install .
RUN /usr/local/bin/mdbook-variables help
