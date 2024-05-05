# frozen_string_literal: true

require_relative 'task'

module GreenDay
  class Contest
    TaskSource = Struct.new(:name, :path, :contest_name)
    attr_reader :name, :task_sources

    def initialize(contest_name)
      @name = contest_name

      @task_sources = fetch_task_names_and_paths.map do |name, path|
        TaskSource.new(name, path, @name)
      end
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
