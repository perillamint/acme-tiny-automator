#!/bin/bash

LETSENCRYPT_AUTO_DIR=/etc/letsencrypt-auto
ACME_DIR=/var/www/challenges

TEMP=$(getopt -o "" --long confdir:,acme-dir: -n 'renew.sh' -- "$@")
eval set -- "$TEMP"

while true
do
    case "$1" in
        --confdir)
            LETSENCRYPT_AUTO_DIR=$2; shift 2;;
        --acme-dir)
            ACME_DIR=$2; shift 2;;
        --) shift; break;;
        *) echo "Error! Cannot parse options!"; exit 1;;
    esac
done

if [ ! -f $LETSENCRYPT_AUTO_DIR"/domains.txt" ]
then
    echo "Error! domains.txt does not exist!"
    exit 1
fi

if [ ! -d $ACME_DIR ]
then
    echo "Error! ACME challenge directory is not a directory!"
    exit 1
fi

# TODO: check emptiness of args.

DOMAIN_LIST=$LETSENCRYPT_AUTO_DIR"/domains.txt"

for domain in $(cat $DOMAIN_LIST)
do
    ./renew.sh --domain $domain --acme-dir=$ACME_DIR
done
