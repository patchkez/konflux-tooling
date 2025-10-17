# Konflux tools for managing repositories with konflux pipelines/hermetic builds
## Generate rpms.lock.yaml
Build container image manually:
```
podman build -t quay.io/patchkez101/konflux-tooling:latest -f Containerfile
```

Or pull built image from quay:
```
podman pull quay.io/patchkez101/konflux-tooling:latest
```

Change directory to repo you want to manage and export needed variables:
```
cd <to dir/repo with rpms.lock.yaml>
export KEY_NAME=<activation-key-name>
export ORG_ID=<org-id>
```

Run container for generation of rpm.lock.yaml:
```
podman run --rm -e KEY_NAME=${KEY_NAME} -e ORG_ID=${ORG_ID} -v $(pwd):/app/:Z quay.io/patchkez101/konflux-tooling:latest
```

Note: Watch out for any WARNINGS as they might be related to not enabled repositories.

## TODO
- print enabled repos
- make enabling of additional repos configurable (hardcoded rhel-9-for-x86_64-baseos-source-rpms / rhel-9-for-x86_64-appstream-source-rpms)
- make --image option configurable
