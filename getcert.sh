#!/bin/bash

ACME_TINY_SCRIPT="acme-tiny/acme_tiny.py"
AUTO_DIR="/etc/letsencrypt-auto/"
ACME_DIR="/var/www/challenges"
ACCOUNT_KEY=$AUTO_DIR"/account.key"

TEMP=$(getopt -o "o:" --long account-key:,acme-dir:,fqdn:,csr: -n 'getcert.sh' -- "$@")
eval set -- "$TEMP"

while true
do
    case "$1" in
        --account-key)
            ACCOUNT_KEY=$2; shift 2;;
        --acme-dir)
            ACME_DIR=$2; shift 2;;
        --fqdn)
            FQDN=$2; shift 2;;
        --csr)
            CSR_FILE=$2; shift 2;;
        -o)
            OUTPUT_FILE=$2; shift 2;;
        --) shift; break;;
        *) echo "Error! Cannot parse options!"; exit 1;;
    esac
done

if [ $FQDN ]
then
    CSR_FILE=$AUTO_DIR"/csrs/"$FQDN".csr"
    OUTPUT_FILE=$AUTO_DIR"/certs/"$FQDN"/cert.pem"
fi

if [ ! -f $ACCOUNT_KEY ]
then
    echo "Error! account key is not a file!"
    exit 1
fi

if [ ! -d $ACME_DIR ]
then
    echo "Error! acme dir is not a directory!"
    exit 1
fi

if [ ! -f $CSR_FILE ]
then
    echo "Error! csr file is not a file!"
    exit 1
fi

# TODO: check emptiness of args.

python $ACME_TINY_SCRIPT --account-key $ACCOUNT_KEY --acme-dir $ACME_DIR \
       --csr $CSR_FILE > $OUTPUT_FILE
