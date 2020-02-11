# frozen_string_literal: true

require 'thor'
require 'io/console'
require_relative 'atcoder_client'
require_relative 'contest'
require_relative 'test_builder'

module GreenDay
  class Cli < Thor
    desc 'login Atcoder', 'login Atcoder and save session'
    def login
      print 'username:'
      username = STDIN.gets.chomp!
      password = STDIN.getpass('password:').chomp!

      AtcoderClient.new.login(username, password)
    end

    desc 'new [contest name]', 'create contest workspace and spec'
    def new(contest_name)
      contest = Contest.new(contest_name)
      FileUtils.makedirs("#{contest_name}/spec")

      contest.tasks.each do |task|
        task_code = task.code
        answer = File.open("#{contest_name}/#{task_code}.rb", 'w')
        test = TestBuilder.build_test(answer, task.input_output_hash)

        File.open("#{contest.name}/spec/#{task_code}_spec.rb", 'w') do |f|
          f.write(test)
        end
      end
    end
  end
end
