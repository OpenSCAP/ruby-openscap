# -*- encoding: utf-8 -*-
require 'date'

GEMSPEC = Gem::Specification.new do |gem|
  gem.name = "openscap"
  gem.version = File.open('VERSION').readline.chomp
  gem.date = Date.today.to_s
  gem.platform = Gem::Platform::RUBY

  gem.author = "Šimon Lukašík"
  gem.email = "isimluk@fedoraproject.org"
  gem.homepage = "https://github.com/OpenSCAP/ruby-openscap"
  gem.license = "GPL-2.0"

  gem.summary = "A FFI wrapper around the OpenSCAP library"
  gem.description = "A FFI wrapper around the OpenSCAP library.
  Currently it provides only subset of libopenscap functionality."

  gem.add_development_dependency "bundler", ">=1.0.0"
  gem.add_runtime_dependency "ffi", ">= 1.4.0"

  gem.files = `git ls-files`.split("\n")
  gem.require_path = 'lib'
  gem.required_ruby_version = '>= 2.0.0'
end
