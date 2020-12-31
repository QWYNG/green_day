# frozen_string_literal: true

module GreenDay
  class Task
    attr_reader :contest, :code, :sample_answers

    def initialize(contest, code, client)
      @contest = contest
      @code = code
      @sample_answers = create_sample_answers(client)
    end

    private

    def create_sample_answers(client)
      input_samples, output_samples =
        client.fetch_inputs_and_outputs(contest, self)

      input_samples.zip(output_samples).to_h
    end
  end
end
