#!/bin/bash
set -e

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  echo "Usage: `basename $0` -- Creates a new signup link
  options:
  --user-email  Pass the email address for the new user, so there is no need to prompt for it
  --help        Show this help"
  exit 0
fi

if [[ "$1" == "--user-email" ]]; then
    EMAIL="$2"
else
    echo "What is the new user's current email address?"
    read EMAIL
fi


AUTH_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
echo "$EMAIL:$AUTH_SECRET" >> /mnt/docker/accounts/auth.file
DOMAIN=$(grep ^DOMAIN= "/mnt/docker/.env" | awk -F= '{ print $NF }')
SIGNUP_URL="https://welcome.$DOMAIN/?authmail=$EMAIL&authsecret=$AUTH_SECRET"
echo "The new user can sign up now at $SIGNUP_URL"

echo -e "Subject:Signup for $DOMAIN
You can now sign up for your $DOMAIN account at $SIGNUP_URL" | \
docker-compose exec -T eelomailserver sendmail -f "drive@$DOMAIN" -t "$EMAIL"
