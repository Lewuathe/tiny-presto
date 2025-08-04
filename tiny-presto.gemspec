# frozen_string_literal: true

require File.expand_path 'lib/tiny-presto/version', File.dirname(__FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'tiny-presto'
  gem.version       = TinyPresto::VERSION

  gem.authors       = ['Kai Sasaki']
  gem.email         = ['lewuathe@me.com']
  gem.description   = 'Wrapper for Lightweight Presto Cluster'
  gem.summary       = 'For Presto functionality testing'
  gem.homepage      = 'https://github.com/Lewuathe/tiny-presto'
  gem.license       = 'Apache-2.0'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  gem.has_rdoc = false

  gem.required_ruby_version = '>= 3.2.0'

  gem.add_dependency 'docker-api', ['>= 2.0.0', '< 3.0']
  gem.add_dependency 'trino-client'

  gem.add_development_dependency 'rake', ['~> 13.0.0']
  gem.add_development_dependency 'rspec', ['~> 3.12.0']
end
