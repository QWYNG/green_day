# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'green_day/version'

Gem::Specification.new do |spec|
  spec.name          = 'green_day'
  spec.executables   = ['green_day']
  spec.version       = GreenDay::VERSION
  spec.authors       = ['qwyng']
  spec.email         = ['ikusawasi@gmail.com']

  spec.summary       = 'CLI tool for AtCoder and Ruby'
  spec.description   = 'CLI tool for AtCoder and Ruby'
  spec.homepage      = 'https://github.com/QWYNG/green_day'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '< 1.0'
  spec.add_dependency 'faraday-cookie_jar'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'rspec', '~> 3.0'
  spec.add_dependency 'thor'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'codecov'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rubocop'
end
