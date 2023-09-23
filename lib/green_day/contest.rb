# frozen_string_literal: true

require_relative 'task'

module GreenDay
  class Contest
    attr_reader :name, :tasks

    def initialize(contest_name)
      @name = contest_name

      @tasks = fetch_task_names_and_paths.map do |task_name, task_path|
        Thread.new do
          Task.new(self, task_name, task_path)
        end
      end.map(&:value)
    end

    private

    def fetch_task_names_and_paths
      body = AtcoderClient.get_parsed_body("contests/#{name}/tasks")
      task_elements = body.search('tbody tr td:first a')

      task_elements.to_h do |element|
        [element.text, element[:href]]
      end
    end
  end
end
