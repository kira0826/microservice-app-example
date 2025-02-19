#!/bin/sh

# Currently we are using gettext to insert this env variables on the specified file.
envsubst '${AUTH_API_ADDRESS} ${TODOS_API_ADDRESS}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Run Nginx web server.
exec nginx -g 'daemon off;'