FROM node:10-alpine

WORKDIR /app

COPY *.json /app/
COPY src /app/src/

RUN npm install

CMD ./node_modules/.bin/ng serve --host 0.0.0.0
