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

      AtcoderClient.new.login(username, password)
      puts(
        "Successfully created #{AtcoderClient::COOKIE_FILE_NAME}"
        .colorize(:green)
      )
    end

    desc 'new [contest name]', 'create contest workspace and spec'
    def new(contest_name)
      contest = Contest.new(contest_name, AtcoderClient.new)
      FileUtils.makedirs("#{contest.name}/spec")

      Parallel.each(contest.tasks) do |task|
        create_submit_file(task)
        create_spec_file(task)
      end

      puts "Successfully created #{contest.name} directory".colorize(:green)
    end

    private

    def create_submit_file(task)
      File.open(submit_file_path(task), 'w')
    end

    def create_spec_file(task)
      test =
        TestBuilder.build_test(
          submit_file_path(task),
          task.sample_answers
        )
      File.open(spec_file_path(task), 'w') do |f|
        f.write(test)
      end
    end

    def submit_file_path(task)
      "#{task.contest.name}/#{task.code}.rb"
    end

    def spec_file_path(task)
      "#{task.contest.name}/spec/#{task.code}_spec.rb"
    end
  end
end
