#!/usr/bin/env bash

_module_run_optional() {
    local module="${1}"
    local fn="${2}"
    shift 2

    unset "${fn}"
    source "${module}"

    if [[ $(type -t "${fn}") != function ]]; then
        _log_debug "skipping ${module}::${fn}, not present"
        return
    fi

    _log_debug "running ${module}::${fn}"
    ${fn} "${@}"
}

_modules_run_hooks_optional() {
    local hook=${1}
    shift

    for module in "${_CHROOT_MODULES}"/*.sh; do
        _module_run_optional "${module}" "${hook}" "${@}"
    done
}

_modules_setup() {
    _msg1 "Run module setup hooks..."
    _modules_run_hooks_optional setup
}

_modules_install() {
    _msg1 "Run module install hooks..."
    _modules_run_hooks_optional install
}
