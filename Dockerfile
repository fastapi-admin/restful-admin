FROM node:12.18-slim

WORKDIR /app

COPY package.json .
COPY yarn.lock .

RUN yarn install

COPY . .

ENTRYPOINT ["yarn", "run", "serve"]
