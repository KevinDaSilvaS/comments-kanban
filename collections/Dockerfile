  
FROM node:alpine

EXPOSE 5000

COPY . .

RUN npx insomnia-documenter --config comments-kanban.json 

CMD npx serve