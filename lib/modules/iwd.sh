#!/usr/bin/env bash

install() {
    _msg2 "Enabling iwd.service..."

    systemctl enable iwd.service
}
