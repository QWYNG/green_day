# frozen_string_literal: true

require 'bundler/setup'
require 'green_day'
require 'dotenv/load'
require 'vcr'
require 'simplecov'
SimpleCov.start

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :faraday
  config.configure_rspec_metadata!
  config.default_cassette_options = { match_requests_on: [:method, :uri]}
  config.filter_sensitive_data('<USERNAME>') { ENV['USER_NAME'] }
  config.filter_sensitive_data('<PASSWORD>') { ENV['PASSWORD'] }
  config.before_record do |i|
    # Cassettes in tests that require set-cookie are manually overwritten.
    i.response.headers.delete('set-cookie')
    i.request.headers.delete('Cookie')
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

::Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }
::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
