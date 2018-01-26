FROM ruby:alpine

LABEL maintainer="mbeiner@crystalnix.com"

WORKDIR app
EXPOSE 3000

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock

RUN apk add --no-cache --virtual dev-deps gcc g++ build-base \
    linux-headers && bundle install

ADD . /app/

CMD puma config.ru -w 2 -t 0:4 -p 3000
