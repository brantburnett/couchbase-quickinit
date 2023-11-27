ARG COUCHBASE_TAG=enterprise-7.2.3
FROM couchbase:${COUCHBASE_TAG}

# Configure apt-get for NodeJS
# Install NPM and NodeJS and jq, with apt-get cleanup
RUN apt-get update && \
    apt-get install -yq ca-certificates curl gnupg jq && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    NODE_MAJOR=20 && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -yq nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install couchbase-index-manager
RUN mkdir -p /npm-packages && \
    npm config set prefix /npm-packages && \
    npm install -g --unsafe-perm couchbase-index-manager-cli@2.1.2 && \
    rm -rf /tmp/* /var/tmp/*
ENV PATH="/npm-packages/bin:$PATH"

# Copy startup scripts
COPY ./scripts/ /scripts/
COPY ./startup/ /startup/

# Configure default environment
ENV CB_DATARAM=512 CB_INDEXRAM=256 CB_SEARCHRAM=256 CB_ANALYTICSRAM=1024 CB_EVENTINGRAM=256 \
    CB_SERVICES=kv,n1ql,index,fts CB_INDEXSTORAGE=forestdb \
    CB_USERNAME=Administrator CB_PASSWORD=password

RUN mkdir /nodestatus
VOLUME /nodestatus

ENTRYPOINT ["/scripts/configure-node.sh"]
