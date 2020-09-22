FROM ubuntu:bionic-20200903 as builder

RUN apt-get update && \
    apt-get install -y curl && \
    cd /tmp && \
    curl -L -O https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.2%2B12/OpenJDK14U-jdk_x64_linux_hotspot_14.0.2_12.tar.gz && \
    tar xvf ./OpenJDK14U-jdk_x64_linux_hotspot_14.0.2_12.tar.gz

# --------------------------------
FROM ubuntu:bionic-20200903

# OpenJDK
COPY --from=builder /tmp/jdk-14.0.2+12 /usr/local/jdk-14.0.2+12
ENV JAVA_HOME "/usr/local/jdk-14.0.2+12"
ENV PATH "$JAVA_HOME/bin:$PATH"

# app
RUN useradd app
RUN mkdir /app
RUN chown -R app:app /app
USER app
COPY --chown=app:app ./build/libs/*.jar /app/app.jar

CMD ["bash"]
