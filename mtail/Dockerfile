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
RUN mkdir /app
RUN chown -R app:app /app
USER app
COPY --from=builder --chown=app:app /tmp/mtail /app/mtail
COPY --chown=app:app ./docker-entrypoint.sh /app/docker-entrypoint.sh
COPY --chown=app:app ./jvm-jit-compilation.mail /app/jvm-jit-compilation.mail

CMD ["/app/docker-entrypoint.sh"]
