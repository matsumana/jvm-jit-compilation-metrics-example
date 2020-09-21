FROM ubuntu:bionic-20200903 as builder

RUN apt-get update && \
    apt-get install -y curl && \
    cd /tmp && \
    curl -L -O https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15%2B36/OpenJDK15U-jdk_x64_linux_hotspot_15_36.tar.gz && \
    tar xvf ./OpenJDK15U-jdk_x64_linux_hotspot_15_36.tar.gz

# --------------------------------
FROM ubuntu:bionic-20200903

# OpenJDK
COPY --from=builder /tmp/jdk-15+36 /usr/local/jdk-15+36
ENV JAVA_HOME "/usr/local/jdk-15+36"
ENV PATH "$JAVA_HOME/bin:$PATH"

# app
RUN useradd app
RUN mkdir /app
RUN chown -R app:app /app
USER app
COPY --chown=app:app ./build/libs/*.jar /app/app.jar

CMD ["bash"]
