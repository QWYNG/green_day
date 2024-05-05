# frozen_string_literal: true

require_relative 'test_builder'

module GreenDay
  class TaskSourceToFileWorker
    def self.run_threads(task_sources)
      new(task_sources).run_threads
    end

    def initialize(task_sources)
      @task_sources = task_sources
    end

    def run_threads
      @task_sources.map.with_index do |task_source, i|
        # avoid 429 error
        sleep 1 if (i % 7).zero? && !i.zero?

        Thread.new do
          task = Task.new(task_source.name,
                          task_source.path,
                          task_source.contest_name)
          task.create_file
          task.create_spec_file
        end
      end
    end
  end
end
