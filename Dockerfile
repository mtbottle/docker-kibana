FROM alpine:3.2

ENV KIBANA_VERSION 4.3.0-linux-x64

RUN apk --update add curl && \
    mkdir /opt && \
    curl -s https://download.elasticsearch.org/kibana/kibana/kibana-${KIBANA_VERSION}.tar.gz | tar zx -C /opt && \
    apk add nodejs && \
    rm -rf /opt/kibana-${KIBANA_VERSION}/node && \
    mkdir -p /opt/kibana-${KIBANA_VERSION}/node/bin && \
    ln -sf /usr/bin/node /opt/kibana-${KIBANA_VERSION}/node/bin/node && \
    apk del curl && \
    rm -rf /var/cache/apk/*

# Install marvel app to kibana
RUN /opt/kibana-${KIBANA_VERSION}/bin/kibana plugin --install elasticsearch/marvel/latest
RUN /opt/kibana-${KIBANA_VERSION}/bin/kibana plugin --install elastic/sense

ADD ./run_kibana.sh /run_kibana.sh

EXPOSE 5601

ENTRYPOINT /run_kibana.sh