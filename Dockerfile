FROM ruby:alpine

LABEL maintainer="mbeiner@crystalnix.com"

WORKDIR app
EXPOSE 3000

ADD Gemfile Gemfile
RUN apk add --no-cache --virtual dev-deps gcc g++ build-base \
    linux-headers && \
    bundle install

RUN mkdir tmp && mkdir log

ADD . /app/

CMD unicorn -c unicorn.rb
