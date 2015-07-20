FROM ruby:2.2.0

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install --no-cache --jobs=10 --without development test deployer

COPY . /usr/src/app

CMD bin/puma -C config/puma.rb

EXPOSE 9292
