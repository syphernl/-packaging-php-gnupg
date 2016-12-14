#!/bin/bash
BUILDER_IMAGE="registry.gitlab.com/syphernl/docker-builder-${UBUNTU_DIST:-xenial}:latest"
BUILD_CMDS="cd /build; ./prepare.sh; ./update.sh && bash -x ./build.sh && chown 1000:1000 packages/*.deb"

docker run --env UBUNTU_DIST="${UBUNTU_DIST:-xenial}" --env APP_VERSION="${APP_VERSION:-1.0}" -v ${PWD}:/build --rm -i -t ${BUILDER_IMAGE} bash -c "${BUILD_CMDS}"
