# frozen_string_literal: true

require 'forwardable'
require_relative 'task'

module GreenDay
  class Contest
    extend Forwardable
    delegate get_parsed_body: :@client

    attr_reader :name, :tasks

    def initialize(contest_name, client)
      @client = client
      @name = contest_name

      task_names_and_paths = fetch_task_names_and_paths
      @tasks =
        Parallel.map(task_names_and_paths,
                     in_threads: THREAD_COUNT) do |task_name, task_path|
          Task.new(self, task_name, task_path, @client)
        end
    end

    private

    def fetch_task_names_and_paths
      body = get_parsed_body("contests/#{name}/tasks")
      task_elements = body.search('tbody tr td:first a')

      task_elements.to_h do |element|
        [element.text, element[:href]]
      end
    end
  end
end
