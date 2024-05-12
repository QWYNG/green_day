# frozen_string_literal: true

require_relative 'green_day/version'
require_relative 'green_day/cli'

module GreenDay
  class Error < StandardError; end
  TEMPLATE_FILE_PATH = File.expand_path('green_day/template.rb', __dir__)
end
