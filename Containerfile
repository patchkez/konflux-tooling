ARG UBI_VERSION=9
FROM registry.access.redhat.com/ubi${UBI_VERSION}/ubi:latest

ARG UBI_VERSION
ARG GIT_REF=heads/main

RUN dnf install -y python3 python3-pip python3-dnf skopeo rpm git-core && \
    mkdir /opt/bin
WORKDIR /app

RUN python3 -m pip install https://github.com/konflux-ci/rpm-lockfile-prototype/archive/refs/${GIT_REF}.tar.gz
ADD ./gen-rpms-lock-yaml.sh /opt/bin
COPY --from=quay.io/konflux-ci/yq:latest /usr/bin/yq /opt/bin

ENV UBI_VERSION=$UBI_VERSION
ENV PATH=${PATH}:/opt/bin

ENTRYPOINT ["/opt/bin/gen-rpms-lock-yaml.sh"]
