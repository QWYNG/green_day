# frozen_string_literal: true

require_relative 'atcoder_client'
require_relative 'task'

module GreenDay
  class Contest
    attr_reader :atcoder_client, :name, :tasks

    def initialize(contest_name, client)
      raise GreenDay::Error 'cant find contest' unless client.contest_exist?(contest_name)

      @name = contest_name
      @tasks = Parallel.map(client.fetch_task_codes(self)) do |task_code|
        Task.new(self, task_code, client)
      end
    end
  end
end
