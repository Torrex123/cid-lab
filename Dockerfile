FROM node:7.8.0
WORKDIR /opt
ADD . /opt
RUN npm install
EXPOSE 3000
CMD ["npm", "start"]