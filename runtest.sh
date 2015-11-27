set -e -o pipefail
set -x

rm openscap-*.gem || true
gem build openscap.gemspec
gem install openscap-*.gem
rake test
rubocop
