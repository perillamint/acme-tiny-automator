#!/bin/bash

LETSENCRYPT_AUTO_DIR=/etc/letsencrypt-auto

TEMP=$(getopt -o "" --long confdir: -n 'buildchain.sh' -- "$@")
eval set -- "$TEMP"

while true
do
    case "$1" in
        --confdir)
            LETSENCRYPT_AUTO_DIR=$2; shift 2;;
        --) shift; break;;
        *) echo "Error! Cannot parse options!"; exit 1;;
    esac
done

if [ ! -f $LETSENCRYPT_AUTO_DIR"/domains.txt" ]
then
    echo "Error! domains.txt does not exist!"
    exit 1
fi

# TODO: check emptiness of args.

DOMAIN_LIST=$LETSENCRYPT_AUTO_DIR"/domains.txt"
INTERMEDIATE_CHAIN=$LETSENCRYPT_AUTO_DIR"/intermediate.pem"

curl https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem > $INTERMEDIATE_CHAIN

for domain in $(cat $DOMAIN_LIST)
do
    CERT=$LETSENCRYPT_AUTO_DIR"/certs/"$domain"/cert.pem"
    FULLCHAIN=$LETSENCRYPT_AUTO_DIR"/certs/"$domain"/fullchain.pem"

    cat $CERT $INTERMEDIATE_CHAIN > $FULLCHAIN
done
