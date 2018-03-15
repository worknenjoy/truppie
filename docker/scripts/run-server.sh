#!/usr/bin/env bash

rm -rf tmp && \
rake db:create && \
rake db:migrate && \
rails s -b 0.0.0.0 -p 3000
