# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'green_day/version'

Gem::Specification.new do |spec|
  spec.name          = 'green_day'
  spec.version       = GreenDay::VERSION
  spec.authors       = ['qwyng']
  spec.email         = ['ikusawasi@gmail.com']

  spec.summary       = 'CLI tool for AtCoder and Ruby'
  spec.description   = 'CLI tool for AtCoder and Ruby'
  spec.homepage      = 'https://github.com/QWYNG/green_day'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.add_dependency 'httpclient'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'thor'
  spec.add_development_dependency 'aruba'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
