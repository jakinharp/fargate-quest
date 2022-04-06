FROM node:latest

WORKDIR /code

COPY . .

ENV PORT 3000

RUN npm install

EXPOSE $PORT

COPY . .

CMD node src/000.js && sleep infinity