#!/usr/bin/env bash

function should-apt-update() {
    seconds=$((60 * 100))
    if [[ "$(($(date +%s) - $(stat -c %Y /var/cache/apt/pkgcache.bin)))" -gt "${seconds}" ]]; then
        true
        return
    fi

    false
    return
}
