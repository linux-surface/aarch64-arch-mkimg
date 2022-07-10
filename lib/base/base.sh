#!/usr/bin/env bash

_root_check() {
    if ! [[ ${UID} -eq 0 ]]; then
        _log_error "This script requires root privileges!"
        exit 1
    fi
}

_run_module_fn() {
    local module="${1}"
    local fn="${2}"
    shift 2

    unset "${fn}"
    source "${module}"

    if [[ $(type -t "${fn}") != function ]]; then
        _log_error "function '${fn}' not found in '${module}'"
        return 1
    fi

    _log_debug "running ${module}::${fn}"
    ${fn} "${@}"
}

_pushd() {
    pushd "${1}" >> /dev/null || return 1
}

_popd() {
    popd >> /dev/null || return 1
}
