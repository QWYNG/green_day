# frozen_string_literal: true

module GreenDay
  class Task
    SampleAnswer = Struct.new(:input, :output)
    attr_reader :name, :path, :contest_name

    def initialize(name, path, contest_name)
      @name = name
      @path = path
      @contest_name = contest_name
    end

    def create_file
      FileUtils.touch(file_name)
    end

    def create_spec_file
      test_content = TestBuilder.build_test(
        file_name,
        sample_answers
      )
      File.write("#{contest_name}/spec/#{name}_spec.rb", test_content)
    end

    private

    def sample_answers
      input_samples, output_samples = fetch_inputs_and_outputs

      input_samples.zip(output_samples).map do |input, output|
        SampleAnswer.new(input, output)
      end
    end

    def fetch_inputs_and_outputs
      body = AtcoderClient.get_parsed_body(path)
      samples = body.css('.lang-ja > .part > section > pre').map { |e| e.children.text }

      inputs, outputs = samples.partition.with_index { |_sample, i| i.even? }

      [inputs, outputs]
    end

    def file_name
      "#{contest_name}/#{name}.rb"
    end
  end
end
