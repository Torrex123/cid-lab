FROM node:7.8.0
WORKDIR /opt
ADD . /opt
RUN npm install

ENV PORT=3000
EXPOSE $PORT

CMD ["npm", "start"]