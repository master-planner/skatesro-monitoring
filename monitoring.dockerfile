FROM fedora:36
ARG SKATES_FOLDER=/root/monitoring

ENV AWS_ACCESS_KEY_ID=changeme
ENV AWS_SECRET_ACCESS_KEY=changeme

RUN mkdir -p ${SKATES_FOLDER} || true && \
    cd ${SKATES_FOLDER} && \
    yum install -y python3 && \
    python3 -m venv .venv && \
    . .venv/bin/activate && \
    pip3 install --upgrade pip && \
    pip3 install awscli

COPY docker-entrypoint.sh /root/docker-entrypoint.sh
COPY monitoring.sh /root/monitoring.sh

RUN chmod u+x /root/monitoring.sh && \
    chmod u+x /root/docker-entrypoint.sh

WORKDIR /root
ENTRYPOINT ["./docker-entrypoint.sh"]