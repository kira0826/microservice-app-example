#We ensure node version specified.
FROM node:8.17

WORKDIR /app

# Ensure npm version specified

RUN npm install -g npm@6.13.4

COPY package*.json ./

RUN npm install

COPY . .

CMD ["npm", "start"]