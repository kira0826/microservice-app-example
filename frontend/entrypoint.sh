#!/bin/sh

# Reemplaza AUTH_API_ADDRESS y TODOS_API_ADDRESS
envsubst '${AUTH_API_ADDRESS} ${TODOS_API_ADDRESS}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Inicia Nginx
exec nginx -g 'daemon off;'