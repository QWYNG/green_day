# frozen_string_literal: true

module GreenDay
  class Task
    attr_reader :contest, :code
    def initialize(contest, code)
      @contest = contest
      @code = code
      @input_output_hash = create_input_output_hash
    end

    private

    def create_input_output_hash
      client = AtcoderClient.new

      input_samples, output_samples =
        client.fetch_inputs_and_outputs(contest, self)

      hash = {}
      input_samples.zip(output_samples).each do |input, output|
        hash[input] = output
      end

      hash
    end
  end
end
