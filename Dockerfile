FROM alpine as builder
ENV LITECOIN_VERSION=0.18.1
ENV LITECOIN_TARBALL_URL=https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz
# checksum file explicitly stored in version control for security reasons
COPY litecoin-${LITECOIN_VERSION}-linux-signatures.asc /usr/src/
WORKDIR /usr/src
RUN apk add --update --no-cache curl outils-sha256 && \
    curl -Ssv "$LITECOIN_TARBALL_URL" > litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    echo "$(grep litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz litecoin-${LITECOIN_VERSION}-linux-signatures.asc)" | sha256sum -c && \
    tar zxvf "litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz" && \
    ln -sv "litecoin-${LITECOIN_VERSION}" ./litecoin

# usually we would compile this in the builder and copy the libs
# which will also ensure version compatibility in dynamic linking
FROM frolvlad/alpine-glibc
LABEL MAINTAINER="Chris Fordham <chris@fordham.id.au>"
# TODO: copy only needed files
COPY --from=builder /usr/src/litecoin/ /opt/litecoin
RUN adduser \
      -h /opt/litecoin \
      -D \
      -H \
        litecoin && \
    chown -R litecoin /opt/litecoin
EXPOSE 9333
WORKDIR /opt/litecoin
USER litecoin
CMD ["bin/litecoind"]
