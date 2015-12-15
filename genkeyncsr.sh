#!/bin/bash

LETSENCRYPT_AUTO_DIR=/etc/letsencrypt-auto

TEMP=$(getopt -o "" --long domain:,confdir: -n 'genkeyncsr.sh' -- "$@")
eval set -- "$TEMP"

while true
do
    case "$1" in
        --domain)
            DOMAIN=$2; shift 2;;
        --confdir)
            LETSENCRYPT_AUTO_DIR=$2; shift 2;;
        --) shift; break;;
        *) echo "Error! Cannot parse options!"; exit 1;;
    esac
done

if [ ! -d $LETSENCRYPT_AUTO_DIR ]
then
    echo "Error! config directory is not a directory!"
    exit 1
fi

# TODO: check emptiness of args.

if [ ! -d $LETSENCRYPT_AUTO_DIR"/csrs" ]
then
    mkdir $LETSENCRYPT_AUTO_DIR"/csrs"
fi

if [ ! -d $LETSENCRYPT_AUTO_DIR"/certs" ]
then
    mkdir $LETSENCRYPT_AUTO_DIR"/certs/"
fi

if [ ! -d $LETSENCRYPT_AUTO_DIR"/certs"$DOMAIN ]
then
    mkdir $LETSENCRYPT_AUTO_DIR"/certs/"$DOMAIN
fi

PRIVKEY=$LETSENCRYPT_AUTO_DIR"/certs/"$DOMAIN"/privkey.pem"
CSR=$LETSENCRYPT_AUTO_DIR"/csrs/"$DOMAIN".csr"

openssl genrsa 4096 > $PRIVKEY
openssl req -new -sha256 -key $PRIVKEY -subj "/CN="$DOMAIN > $CSR
