#!/bin/bash

set -e

# IMAGE="${IMAGE:-$1}"
IMAGE="${1:-"registry.access.redhat.com/ubi${UBI_VERSION}/ubi-minimal"}"

if [ ! -f rpms.in.yaml ];then
  echo "rpms.in.yaml file not found!!!"
  exit 1
fi
if [ `cat rpms.in.yaml | yq '.contentOrigin.repofiles.[]' | grep redhat.repo` ];then
  echo "=== redhat.repo found in rpms.in.yaml, subscription needed... ==="
  if [ -z $KEY_NAME ];then
    echo "Environment variable KEY_NAME is not set"
    exit 1
  fi

  if [ -z $ORG_ID ];then
    echo "Environment variable ORG_ID is not set"
    exit 1
  fi
  SUB=1
fi

if [ $SUB ];then
  echo '=== Running subscription manager register ==='
  subscription-manager register --activationkey="$KEY_NAME" --org="$ORG_ID"

  echo '=== Running subscription manager refresh ==='
  subscription-manager refresh
fi

if [ $SUB ]; then
  echo '=== Enable repositories ==='
  subscription-manager repos --enable=rhel-${UBI_VERSION}-for-x86_64-appstream-source-rpms
  subscription-manager repos --enable=rhel-${UBI_VERSION}-for-x86_64-baseos-source-rpms
fi

echo "=== Looping through repo files ==="
for REPOFILE in `cat rpms.in.yaml | yq '.contentOrigin.repofiles.[]'`;do
  REPOFILE_PATH="/etc/yum.repos.d/$(basename ${REPOFILE})"
  if [ ! -f ${REPOFILE_PATH} ]; then
    echo "File ${REPOFILE} specified in rpms.in.yaml, but not found in /etc/yum.repos.d/"
    exit 1
  fi

  echo "=== Copying repofile ${REPOFILE} ==="
  cp ${REPOFILE_PATH} .

  if [ "$(basename ${REPOFILE})" = "ubi.repo" ]; then
    # Special handling for ubi.repo file
    sed -i "s/ubi-${UBI_VERSION}-codeready-builder/codeready-builder-for-ubi-${UBI_VERSION}-\$basearch/" "${REPOFILE}"
    sed -i "s/\[ubi-${UBI_VERSION}/[ubi-${UBI_VERSION}-for-\$basearch/" "${REPOFILE}"
    echo "ubi.repo file processed"
  fi
done

echo '=== Running rpm-lockfile-prototype ==='
/usr/local/bin/rpm-lockfile-prototype --outfile=./rpms.lock.yaml ./rpms.in.yaml --image="${IMAGE}"

echo '=== replacing sslclientky/sslclientcert with variables for konflux ==='
for REPOFILE in `ls -1 *.repo`;do
  sed -i "s/$(uname -m)/\$basearch/g" ${REPOFILE}
  sed -i 's/sslclientkey = .*/sslclientkey = \$SSL_CLIENT_KEY/g' ${REPOFILE}
  sed -i 's/sslclientcert = .*/sslclientcert = \$SSL_CLIENT_CERT/g' ${REPOFILE}
done

if [ $SUB ]; then
  echo '=== Unregistering with subscription-manager ==='
  subscription-manager unregister
fi
