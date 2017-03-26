#!/bin/bash

if [[ ! -f /etc/letsencrypt-auto/account.key ]]; then
    openssl genrsa 4096 > /etc/letsencrypt-auto/account.key
else
    echo "Account key already exists!"
    exit 1
fi
