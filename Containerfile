FROM registry.access.redhat.com/ubi9/ubi:latest

RUN dnf install -y python3 python3-pip python3-dnf skopeo rpm git-core && \
    mkdir /opt/bin
WORKDIR /app
ARG GIT_REF=heads/main
RUN python3 -m pip install https://github.com/konflux-ci/rpm-lockfile-prototype/archive/refs/${GIT_REF}.tar.gz
# ENTRYPOINT ["/usr/local/bin/rpm-lockfile-prototype"]
ADD ./gen-rpms-lock-yaml.sh /opt/bin
COPY --from=quay.io/konflux-ci/yq:latest /usr/bin/yq /opt/bin
ENV PATH=${PATH}:/opt/bin
ENTRYPOINT ["/opt/bin/gen-rpms-lock-yaml.sh"]
