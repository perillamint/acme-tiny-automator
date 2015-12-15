#!/bin/bash

LETSENCRYPT_AUTO_DIR=/etc/letsencrypt-auto
ACME_DIR=/var/www/challenges

TEMP=$(getopt -o "" --long confdir:,domain:,acme-dir: -n 'renew.sh' -- "$@")
eval set -- "$TEMP"

while true
do
    case "$1" in
        --confdir)
            LETSENCRYPT_AUTO_DIR=$2; shift 2;;
        --domain)
            DOMAIN=$2; shift 2;;
        --acme-dir)
            ACME_DIR=$2; shift 2;;
        --) shift; break;;
        *) echo "Error! Cannot parse options!"; exit 1;;
    esac
done

if [ ! -d $LETSENCRYPT_AUTO_DIR ]
then
    echo "Error! config directory is not a directory!"
    exit 1
fi

if [ ! -d $ACME_DIR ]
then
    echo "Error! ACME challenge directory is not a directory!"
    exit 1
fi

# TODO: check emptiness of args.

ACCOUNT_KEY=$LETSENCRYPT_AUTO_DIR"/account.key"
CSR=$LETSENCRYPT_AUTO_DIR"/csrs/"$DOMAIN".csr"
CERT=$LETSENCRYPT_AUTO_DIR"/certs/"$DOMAIN"/cert.pem"

if [ -f $CSR ]
then
    ./getcert.sh --account-key=$ACCOUNT_KEY --acme-dir=$ACME_DIR \
                 --csr=$CSR -o $CERT
fi
