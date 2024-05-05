# frozen_string_literal: true

require 'thor'
require 'colorize'
require 'io/console'
require_relative 'atcoder_client'
require_relative 'contest'
require_relative 'task_source_to_file_worker'

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

      TaskSourceToFileWorker.run_threads(contest.task_sources).each(&:join)
      puts "Successfully created #{contest.name} directory".colorize(:green)
    end
  end
end
