# frozen_string_literal: true

require_relative 'green_day/version'
require_relative 'green_day/cli'

module GreenDay
  class Error < StandardError; end
  THREAD_COUNT = 6 # There are usually six questions on Atcoder.
end
