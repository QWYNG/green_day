# frozen_string_literal: true

require 'thor'
require 'parallel'
require 'colorize'
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
      puts(
        "Successfully created cookie-store #{AtcoderClient::COOKIE_FILE_NAME}"
        .colorize(:green)
      )
    end

    desc 'new [contest name]', 'create contest workspace and spec'
    def new(contest_name)
      contest = Contest.new(contest_name, AtcoderClient.new)
      FileUtils.makedirs("#{contest_name}/spec")

      Parallel.each(contest.tasks) do |task|
        create_submit_file!(contest_name, task)
        create_spec_file!(contest_name, task)
      end

      puts "Successfully created #{contest_name} directory".colorize(:green)
    end

    private

    def create_submit_file!(contest_name, task)
      File.open(submit_file_path(contest_name, task), 'w') do |f|
        f.write(SnippetBuilder.build)
      end
    end

    def create_spec_file!(contest_name, task)
      test =
        TestBuilder.build_test(
          submit_file_path(contest_name, task),
          task.input_output_hash
        )
      File.open(spec_file_path(contest_name, task), 'w') do |f|
        f.write(test)
      end
    end

    def submit_file_path(contest_name, task)
      "#{contest_name}/#{task.code}.rb"
    end

    def spec_file_path(contest_name, task)
      "#{contest_name}/spec/#{task.code}_spec.rb"
    end
  end
end
