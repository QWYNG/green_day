# frozen_string_literal: true

require_relative 'task'

module GreenDay
  class Contest
    attr_reader :name, :tasks

    def initialize(contest_name)
      @name = contest_name

      @tasks = fetch_task_names_and_paths.map.with_index do |(task_name, task_path), i|
        if !i.zero? && (i % 10).zero? && !ENV['CI']
          puts 'Sleeping 2 second to avoid 429 error'
          sleep 2
        end

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
