FROM ruby:alpine

LABEL maintainer="mbeiner@crystalnix.com"

WORKDIR app
EXPOSE 3000

ADD Gemfile Gemfile
RUN apk add --no-cache --virtual dev-deps gcc g++ build-base && \
    bundle install && apk del dev-deps

CMD bundle exec passenger start