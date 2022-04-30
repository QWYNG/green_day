# frozen_string_literal: true

require 'forwardable'

module GreenDay
  class Task
    extend Forwardable
    delegate get_parsed_body: :@client

    attr_reader :contest, :name, :path, :sample_answers

    def initialize(contest, name, path, client)
      @client = client
      @contest = contest
      @name = name
      @path = path
      @sample_answers = create_sample_answers_hash
    end

    private

    def create_sample_answers_hash
      input_samples, output_samples = fetch_inputs_and_outputs

      input_samples.zip(output_samples).to_h
    end

    def fetch_inputs_and_outputs
      body = get_parsed_body(path)
      samples = body.css('.lang-ja > .part > section > pre').map { |e| e.children.text }

      inputs, outputs = samples.partition.with_index { |_sample, i| i.even? }

      [inputs, outputs]
    end
  end
end
