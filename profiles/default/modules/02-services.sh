#!/usr/bin/env bash

install() {
    _msg2 "Enabling basic services..."

    systemctl enable iwd.service
}
