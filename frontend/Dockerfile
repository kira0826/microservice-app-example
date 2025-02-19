# Phase 1: Defining build phase to compile code. 
 
FROM node:8.17.0-slim as builder

# Ensuring the env variables can be use on building phase
ARG VUE_APP_ZIPKIN_URL
ENV VUE_APP_ZIPKIN_URL=$VUE_APP_ZIPKIN_URL

WORKDIR /app

# Copy  all dependecies to be install
COPY package*.json ./
RUN npm install npm@6.13.4 -g && \
    npm install

COPY . .
RUN npm run build

# Phase 2: Web server to expose frontend, must redirect request trought nginx proxy.
FROM nginx:alpine

# We must install gettex to insert env varibales on default.conf.template to be used as
# nginx configuration.
RUN apk add --no-cache gettext

# We remove nginx previous files.
RUN rm -rf /etc/nginx/conf.d/*

#Copy nginx template or blueprint where env variables will be insert.
COPY default.conf.template /etc/nginx/conf.d/default.conf.template

#Must execute .sh to apply gettext process and execute nginx web server
COPY entrypoint.sh /entrypoint.sh

# From phase 1 we copy the compiled file and then execute it (Remenber the alias "builder" assign in phase 1). 

COPY --from=builder /app/dist /usr/share/nginx/html

#Convert entrypoint executable
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]