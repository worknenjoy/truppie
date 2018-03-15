#!/usr/bin/env bash
rm -rf tmp
rake db:create && \
rake db:migrate && \
rake test
