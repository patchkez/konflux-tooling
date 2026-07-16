# Konflux tools for managing repositories with konflux pipelines/hermetic builds

This tool is used to generate a `rpms.lock.yaml` file for a given baseimage.
It requires the `rpms.in.yaml` file to be present in the format as described in the [Konflux documentation](https://konflux-ci.dev/docs/building/prefetching-dependencies/#rpm).

## Available images

Images are published to `quay.io/patchkez101/konflux-tooling` with UBI version tags:

| UBI Version | Tag |
|-------------|-----|
| UBI 9 | `quay.io/patchkez101/konflux-tooling:ubi9-latest` |
| UBI 10 | `quay.io/patchkez101/konflux-tooling:ubi10-latest` |

## Usage

```
podman run -it --rm -e KEY_NAME="activation-key-name" -e ORG_ID="org-id" -v $(pwd):/app/:Z quay.io/patchkez101/konflux-tooling:ubi9-latest [image-base]

or

podman run -it --rm -e KEY_NAME="activation-key-name" -e ORG_ID="org-id" -v $(pwd):/app/:Z quay.io/patchkez101/konflux-tooling:ubi10-latest [image-base]
```

By default, the tool will use the image `registry.access.redhat.com/ubi<version>/ubi-minimal:latest` if no image-base is provided.

Note: Watch out for any WARNINGS as they might be related to not enabled repositories.

You may alias these commands to a shorter name for convenience:
```
alias update-rpmlock-9='podman run -it --rm -e KEY_NAME="activation-key-name" -e ORG_ID="org-id" -v $(pwd):/app/:Z quay.io/patchkez101/konflux-tooling:ubi9-latest'
alias update-rpmlock-10='podman run -it --rm -e KEY_NAME="activation-key-name" -e ORG_ID="org-id" -v $(pwd):/app/:Z quay.io/patchkez101/konflux-tooling:ubi10-latest'
```

## Building the tool

Build container image manually for UBI 9 (default):
```
podman build -t quay.io/patchkez101/konflux-tooling:ubi9-latest -f Containerfile
```

Build for UBI 10:
```
podman build --build-arg UBI_VERSION=10 -t quay.io/patchkez101/konflux-tooling:ubi10-latest -f Containerfile
```

## TODO
- print enabled repos
- make --image option configurable
