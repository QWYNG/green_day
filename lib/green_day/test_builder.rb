# frozen_string_literal: true

module GreenDay
  module TestBuilder
    module_function

    def build_test(answer, input_output_hash)
      <<~SPEC
        require 'rspec'

        RSpec.describe 'test' do
        #{input_output_hash.map { |input, output| build_example(answer, input, output) }.join("\n")}
        end
      SPEC
    end

    def build_example(answer, input, output)
      <<~SPEC
        #{tab}it 'test with #{unify_cr_lf(input)}' do
        #{tab}#{tab}io = IO.popen("ruby #{answer.path}", "w+")
        #{tab}#{tab}io.puts(#{unify_cr_lf(input)})
        #{tab}#{tab}expect(io.gets).to eq(#{unify_cr_lf(output)})
        #{tab}end
      SPEC
    end

    def unify_cr_lf(string)
      string.gsub(/\R/, "\n").dump
    end

    def tab
      "\s\s"
    end
  end
end
