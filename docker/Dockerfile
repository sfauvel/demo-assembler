FROM alpine:3.11.6
ENV NASM_VERSION 2.14.02-r0

# Compatibility between alpine and nasm

# FROM alpine:3.11
# ENV NASM_VERSION 2.14.02-r0
# FROM alpine:3.10
# ENV NASM_VERSION 2.14.02-r0
# FROM alpine:3.9
# ENV NASM_VERSION 2.13.03-r0
# FROM alpine:3.8
# ENV NASM_VERSION 2.13.03-r0
# FROM alpine:3.7
# ENV NASM_VERSION 2.13.01-r0
# FROM alpine:3.6
# ENV NASM_VERSION 2.12.02
# FROM alpine:3.5
# ENV NASM_VERSION 2.12.02
# FROM alpine:3.4
# ENV NASM_VERSION 2.11.08

RUN apk add --no-cache \
    bash \
    gcc \
    musl-dev \
    nasm=${NASM_VERSION} \
  && rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/bash"]
