# Fase de construcción
FROM node:8.17.0-slim as builder

WORKDIR /app

# Copia package.json e instala dependencias
COPY package*.json ./
RUN npm install npm@6.13.4 -g && \
    npm install

# Copia el código fuente y construye
COPY . .

RUN npm run build

# Fase de producción con Nginx
FROM nginx:alpine

# Instala gettext (para usar envsubst)
RUN apk add --no-cache gettext

RUN rm -rf /etc/nginx/conf.d/*
COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY entrypoint.sh /entrypoint.sh
COPY --from=builder /app/dist /usr/share/nginx/html
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]