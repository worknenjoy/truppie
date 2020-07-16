FROM ruby:2.3

WORKDIR /truppie

RUN apt-get update \
&& apt-get install -y git \
&& curl -sL https://deb.nodesource.com/setup_8.x | bash - \
&& apt-get install -y nodejs \
&& gem install bundler

ADD . /truppie

RUN bundle install
