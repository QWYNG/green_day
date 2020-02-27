# frozen_string_literal: true

require 'thor'
require_relative 'atcoder_client'
require_relative 'contest'
require_relative 'test_builder'
require_relative 'snippet_builder'

module GreenDay
  class Cli < Thor
    desc 'login Atcoder', 'login Atcoder and save session'
    def login
      print 'username:'
      username = STDIN.gets.chomp!
      print 'password:'
      password = STDIN.gets.chomp!

      AtcoderClient.new.login(username, password)
    end

    desc 'new [contest name]', 'create contest workspace and spec'
    def new(contest_name)
      contest = Contest.new(contest_name)
      FileUtils.makedirs("#{contest_name}/spec")

      contest.tasks.each do |task|
        task_code = task.code

        create_submit_file!(contest_name, task_code)
        create_spec_file!(contest_name, task_code, task.input_output_hash)
      end
    end

    private

    def create_submit_file!(contest_name, task_code)
      File.open(submit_file_path(contest_name, task_code), 'w') do |f|
        f.write(SnippetBuilder.build)
      end

      true
    end

    def create_spec_file!(contest_name, task_code, input_output_hash)
      test =
        TestBuilder.build_test(
          submit_file_path(contest_name, task_code),
          input_output_hash
        )
      File.open(spec_file_path(contest_name, task_code), 'w') do |f|
        f.write(test)
      end

      true
    end

    def submit_file_path(contest_name, task_code)
      "#{contest_name}/#{task_code}.rb"
    end

    def spec_file_path(contest_name, task_code)
      "#{contest_name}/spec/#{task_code}_spec.rb"
    end
  end
end
