FROM ubuntu:bionic-20200903 as builder

RUN apt-get update && \
    apt-get install -y curl && \
    cd /tmp && \
    curl -L -O https://github.com/google/mtail/releases/download/v3.0.0-rc36/mtail_v3.0.0-rc36_linux_amd64 && \
    chmod 755 mtail_v3.0.0-rc36_linux_amd64 && \
    mv mtail_v3.0.0-rc36_linux_amd64 mtail

# --------------------------------
FROM ubuntu:bionic-20200903

RUN useradd app
RUN mkdir -p /mtail/bin
RUN mkdir -p /mtail/conf
RUN chown -R app:app /mtail
USER app

COPY --from=builder --chown=app:app /tmp/mtail /mtail/bin/mtail
COPY --chown=app:app jvm-jit-compilation.mtail /mtail/conf/jvm-jit-compilation.mtail
COPY --chown=app:app ./docker-entrypoint.sh /mtail/docker-entrypoint.sh

CMD ["/mtail/docker-entrypoint.sh"]
