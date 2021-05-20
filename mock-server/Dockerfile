FROM node:alpine

COPY . .

RUN npm install -g json-server

EXPOSE 3000

CMD json-server --watch db.json --middlewares ./response.js --routes routes.json --host 0.0.0.0 
