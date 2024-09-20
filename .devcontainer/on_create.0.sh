#!/bin/sh
set -e

apk update --no-cache
apk add --no-cache \
    openssh-client \
    perl \
    tzdata

for id in $(find /root/.ssh/id_kamaranl@kamaranl.vip* ! -name *.pub); do
    cat "$id" | ssh-add -k -
done

exit 0
