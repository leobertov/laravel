FROM nginx:1.15.0-alpine

RUN rm -rf /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/

RUN apk update
RUN apk add bash

