#!/usr/bin/env bash

_LOG_LEVEL_DEBUG=0
_LOG_LEVEL_INFO=1
_LOG_LEVEL_WARN=2
_LOG_LEVEL_ERROR=3

_LOG_LEVEL=_LOG_LEVEL_INFO


_do_log() {
    local level=${1}
    shift

    if [[ ${level} -ge ${_LOG_LEVEL} ]]; then
        >&2 echo "${@}"
    fi
}

_log_error() {
    _do_log _LOG_LEVEL_ERROR "ERROR:" "${@}"
}

_log_warn() {
    _do_log _LOG_LEVEL_WARN "WARN:" "${@}"
}

_log_info() {
    _do_log _LOG_LEVEL_INFO "INFO:" "${@}"
}

_log_debug() {
    _do_log _LOG_LEVEL_DEBUG "DEBUG:" "${@}"
}


_msg1() {
    echo "  ->" "${@}"
}

_msg2() {
    echo "   -" "${@}"
}

