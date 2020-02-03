# frozen_string_literal: true

require_relative 'atcoder_client'
require_relative 'task'

module GreenDay
  class Contest
    attr_reader :atcoder_client, :name, :tasks

    def initialize(contest_name)
      client = AtcoderClient.new
      raise Error 'cant find contest' unless client.contest_exist?(contest_name)

      @name = contest_name
      @tasks = client.fetch_task_codes(self).map do |task_code|
        Task.new(self, task_code)
      end
    end
  end
end
