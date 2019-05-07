#!/usr/bin/env bash
set -e

source /mnt/repo-base/scripts/base.sh

if [ "$(whoami)" != "root" ]
then
        exit 1
fi

MAILHOST="mail.$DOMAIN"
CONFIG=/mnt/repo-base/config-dynamic/letsencrypt/autorenew/ssl-domains.dat
OPENSSLBIN=/usr/bin/openssl
CERTSTOREBASE=/mnt/repo-base/config-dynamic/letsencrypt/certstore
CERTSTORE=$CERTSTOREBASE/live
SERVERADMIN="admin@$DOMAIN"
PUBIP=0.0.0.0
CERTBOT_IMAGE="certbot/certbot:v0.33.1"

cat "$CONFIG" | while read DOMAIN; do
        # For the first run, we have to use standalone auth because Nginx won't start without the cert files present.
        if [ ! -f "$CERTSTORE/$DOMAIN/fullchain.pem" ]
        then
            docker run -t --rm -v $CERTSTOREBASE:/etc/letsencrypt \
                -p $PUBIP:80:80 -p $PUBIP:443:443 \
                "$CERTBOT_IMAGE" certonly --non-interactive --agree-tos -m $SERVERADMIN -d $DOMAIN \
                --standalone
        else
            docker run -t --rm -v $CERTSTOREBASE:/etc/letsencrypt \
                -v /mnt/repo-base/config-dynamic/letsencrypt/acme-challenge:/etc/letsencrypt/acme-challenge \
                "$CERTBOT_IMAGE" certonly --non-interactive --agree-tos -m $SERVERADMIN -d $DOMAIN \
                --webroot -w /etc/letsencrypt/acme-challenge \
                --post-hook "touch /etc/letsencrypt/live/$DOMAIN/cert-updated"
            CERT_UPDATED_FILE="$CERTSTORE/$DOMAIN/cert-updated"
            if [ -f "$CERT_UPDATED_FILE" ]
            then
                echo "Reloading SSL certificates"
                rm "$CERT_UPDATED_FILE"
                docker exec nginx nginx -s reload
                NVALIDTHRU=$($OPENSSLBIN x509 -enddate -noout -in $CERTSTORE/$DOMAIN/fullchain.pem | awk -F= '{ print $NF }')
                echo "Certificate for $DOMAIN renewed and is valid until: $NVALIDTHRU"
                if [ "$DOMAIN" = "$MAILHOST" ]
                then
                    cd /mnt/repo-base/
                    docker-compose restart eelomailserver
                fi
            fi
        fi
:;done
