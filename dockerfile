FROM node:14
RUN npm install prom-client
WORKDIR /usr/src/app
COPY ./package*.json /usr/src/app/
RUN npm install
COPY ./ /usr/src/app/
EXPOSE 8888
CMD [ "node", "app.js" ]