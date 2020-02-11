FROM ubuntu AS parent

ENV USER_NAME=test_user
ENV USER_ID=9999
ENV SHARED_DIR=/opt/shared

RUN set -xeu; \
    apt update; \
    apt install \
        -yq \
         --no-install-recommends \
         --no-install-suggests \
         acl \
         gosu \
         tree \
    ; \
    echo 'Package installation: OK';

RUN set -xeu; \
    useradd -U -m -s /bin/bash "${USER_NAME}"; \
    usermod -a -G users "${USER_NAME}"; \
    echo "Creating user ${USER_NAME} and adding him to the users group: OK";

RUN set -xeu; \
    mkdir "${SHARED_DIR}"; \
    chown "${USER_NAME}":users "${SHARED_DIR}"; \
    chmod g+s "${SHARED_DIR}"; \
    setfacl -d -m group:users:rwx "${SHARED_DIR}"/; \
    setfacl -m group:users:rwx "${SHARED_DIR}"/; \
    echo 'Set group ACLs to the users group: OK';

ARG BUST_DOCKER_CACHE

RUN set -xeu; \
    gosu "${USER_NAME}" mkdir "${SHARED_DIR}"/u1; \
    gosu "${USER_NAME}" mkdir "${SHARED_DIR}"/u2; \
    mkdir "${SHARED_DIR}"/r1; \
    mkdir "${SHARED_DIR}"/r2; \
    echo 'Create subdirectories: OK';

RUN set -xeu; \
    getfacl "${SHARED_DIR}"; \
    getfacl "${SHARED_DIR}"/u1; \
    getfacl "${SHARED_DIR}"/r1; \
    echo 'Check ACLs on parent image: OK';

RUN set -xeu; \
    gosu "${USER_NAME}" mkdir "${SHARED_DIR}"/r2/u; \
    echo 'user can create directories in subdirs that were created by root'

RUN set -xeu; \
    rm -rf "${SHARED_DIR}"/r1; \
    mkdir "${SHARED_DIR}"/r1; \
    echo 'root can remove/re-create directories that he created'

RUN set -xeu; \
    gosu "${USER_NAME}" rm -rf "${SHARED_DIR}"/u1; \
    gosu "${USER_NAME}" mkdir "${SHARED_DIR}"/u1; \
    echo 'user can remove/re-create directories that he created'
