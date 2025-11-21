# Konflux tools for managing repositories with konflux pipelines/hermetic builds

This tool is used to generate a `rpms.lock.yaml` file for a given baseimage.
It requires the `rpms.in.yaml` file to be present in the format as described in the [Konflux documentation](https://konflux-ci.dev/docs/building/prefetching-dependencies/#rpm).

## Usage

```
podman run -it --rm -e KEY_NAME="activation-key-name" -e ORG_ID="org-id" -v $(pwd):/app/:Z quay.io/patchkez101/konflux-tooling:latest [image-base]
```

By default, the tool will use the image `registry.access.redhat.com/ubi9/ubi-minimal:latest` if no image is provided.

Example:
```
podman run -it --rm -e KEY_NAME="activation-key-name" -e ORG_ID="org-id" -v $(pwd):/app/:Z quay.io/patchkez101/konflux-tooling:latest
```

Note: Watch out for any WARNINGS as they might be related to not enabled repositories.

You may alias this command to a shorter name for convenience:
```
alias update-rpmlock='podman run -it --rm -e KEY_NAME="activation-key-name" -e ORG_ID="org-id" -v $(pwd):/app/:Z quay.io/patchkez101/konflux-tooling:latest"
```

## Building the tool
Build container image manually:
```
podman build -t quay.io/patchkez101/konflux-tooling:latest -f Containerfile
```

## TODO
- print enabled repos
- make enabling of additional repos configurable (hardcoded rhel-9-for-x86_64-baseos-source-rpms / rhel-9-for-x86_64-appstream-source-rpms)
- make --image option configurable
