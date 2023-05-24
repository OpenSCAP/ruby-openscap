#!/bin/bash
set -e -o pipefail
set -x

rm -f openscap-*.gem
gem build openscap.gemspec
#gem install openscap-*.gem
bundle exec rake test
bundle exec rubocop
