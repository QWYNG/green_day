# frozen_string_literal: true

require 'thor'
require_relative 'atcoder_client'
require_relative 'contest'
require_relative 'test_builder'

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

    desc 'new [contest name]', 'create contest workspace and spec'
    def new(contest_name)
      contest = Contest.new(contest_name)

      Dir.mkdir(contest_name)
      Dir.mkdir("#{contest_name}/spec")

      contest.tasks.each do |task|
        answer = File.open("#{contest_name}/#{task.code}.rb", 'w')
        test = TestBuilder.build_test(answer, task.input_output_hash)
        File.open("#{contest.name}/spec/#{task.code}_spec.rb", 'w') do |f|
          f.write(test)
        end
      end
    end
  end
end
