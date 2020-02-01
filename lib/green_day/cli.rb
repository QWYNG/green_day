# frozen_string_literal: true

require 'thor'
require_relative 'atcoder_client'

module GreenDay
  class Cli < Thor
    desc 'login Atcoder', 'login Atcoder and save session'
    def login
      puts 'username:'
      username = STDIN.gets.chomp
      puts 'password:'
      password = STDIN.gets.chomp

      AtcoderClient.new.login(username, password)
    end
  end
end
