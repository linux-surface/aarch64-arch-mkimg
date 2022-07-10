#!/usr/bin/env bash

_pushd() {
    pushd "${1}" >> /dev/null || return 1
}

_popd() {
    popd >> /dev/null || return 1
}
