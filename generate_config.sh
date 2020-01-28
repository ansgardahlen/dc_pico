#!/bin/bash

if [[ -f pico.conf ]]; then
  read -r -p "config file pico.conf exists and will be overwritten, are you sure you want to contine? [y/N] " response
  case $response in
    [yY][eE][sS]|[yY])
      mv pico.conf pico.conf_backup
      ;;
    *)
      exit 1
    ;;
  esac
fi

if [ -z "$PUBLIC_FQDN" ]; then
  read -p "Hostname (FQDN): " -ei "pico.example.org" PUBLIC_FQDN
fi

if [ -z "$ADMIN_MAIL" ]; then
  read -p "Pico admin Mail address: " -ei "mail@example.com" ADMIN_MAIL
fi

[[ -f /etc/timezone ]] && TZ=$(cat /etc/timezone)
if [ -z "$TZ" ]; then
  read -p "Timezone: " -ei "Europe/Berlin" TZ
fi

HTTP_PORT=80

cat << EOF > pico.conf
# ------------------------------
# pico web ui configuration
# ------------------------------
# example.org is _not_ a valid hostname, use a fqdn here.
PUBLIC_FQDN=${PUBLIC_FQDN}

# ------------------------------
# PICO admin user
# ------------------------------
PICO_ADMIN=picoadmin
ADMIN_MAIL=${ADMIN_MAIL}
PICO_PASS=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)

# ------------------------------
# Bindings
# ------------------------------

# You should use HTTPS, but in case of SSL offloaded reverse proxies:
HTTP_PORT=${HTTP_PORT}
HTTP_BIND=0.0.0.0

HTTPS_PORT=443
HTTPS_BIND=0.0.0.0

# Your timezone
TZ=${TZ}

# Fixed project name
#COMPOSE_PROJECT_NAME=pico

EOF

mkdir -p data/pico/pico/conf

