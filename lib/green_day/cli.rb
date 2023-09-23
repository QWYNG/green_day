# frozen_string_literal: true

require 'thor'
require 'parallel'
require 'colorize'
require 'io/console'
require_relative 'atcoder_client'
require_relative 'contest'
require_relative 'test_builder'

module GreenDay
  class Cli < Thor
    desc 'login Atcoder', 'login Atcoder and save session'
    def login
      print 'username:'
      username = $stdin.gets(chomp: true)
      print 'password:'
      password = $stdin.noecho { |stdin| stdin.gets(chomp: true) }.tap { puts }

      AtcoderClient.login(username, password)
      puts(
        "Successfully created #{AtcoderClient::COOKIE_FILE_NAME}"
        .colorize(:green)
      )
    end

    desc 'new [contest name]', 'create contest workspace and spec'
    def new(contest_name)
      contest = Contest.new(contest_name)
      FileUtils.makedirs("#{contest.name}/spec")

      contest.tasks.map do |task|
        create_files_in_thread(task)
      end.each(&:join)

      puts "Successfully created #{contest.name} directory".colorize(:green)
    end

    private

    def create_files_in_thread(task)
      Thread.new do
        create_task_file(task)
        create_task_spec_file(task)
      end
    end

    def create_task_file(task)
      FileUtils.touch(task_file_name(task))
    end

    def create_task_spec_file(task)
      test_content = TestBuilder.build_test(task_file_name(task), task.sample_answers)
      File.write("#{task.contest.name}/spec/#{task.name}_spec.rb", test_content)
    end

    def task_file_name(task)
      "#{task.contest.name}/#{task.name}.rb"
    end
  end
end
