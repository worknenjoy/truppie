FROM ruby:2.2.3

WORKDIR /truppie
ADD . /truppie

RUN apt-get update \
&& apt-get install -y git \
&& curl -sL https://deb.nodesource.com/setup_8.x | bash - \
&& apt-get install -y nodejs

RUN bundle install
