# frozen_string_literal: true

require 'date'
require File.expand_path('lib/openscap/version', __dir__)

GEMSPEC = Gem::Specification.new do |gem|
  gem.name = 'openscap'
  gem.version = OpenSCAP::VERSION
  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 3.2.2'

  gem.author = 'Simon Lukasik'
  gem.email = 'isimluk@fedoraproject.org'
  gem.homepage = 'https://github.com/OpenSCAP/ruby-openscap'
  gem.license = 'GPL-2.0'

  gem.summary = 'A FFI wrapper around the OpenSCAP library'
  gem.description = "A FFI wrapper around the OpenSCAP library.
  Currently it provides only subset of libopenscap functionality."

  gem.add_runtime_dependency 'ffi', '~> 1.15.5'

  gem.files = Dir['{lib,test}/**/*'] + ['COPYING', 'README.md', 'Rakefile']
  gem.require_path = 'lib'
end
