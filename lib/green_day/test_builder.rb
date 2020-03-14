# frozen_string_literal: true

module GreenDay
  module TestBuilder
    module_function

    def build_test(submit_file_path, input_output_hash)
      <<~SPEC
        require 'rspec'

        RSpec.describe 'test' do
        #{input_output_hash.map { |input, output| build_example(submit_file_path, input, output) }.join("\n")}
        end
      SPEC
    end

    def build_example(submit_file_path, input, output)
      <<~SPEC
        #{tab}it 'test with #{unify_cr_lf(input)}' do
        #{tab}#{tab}io = IO.popen("ruby #{submit_file_path}", "w+")
        #{tab}#{tab}io.puts(#{unify_cr_lf(input)})
        #{tab}#{tab}io.close_write
        #{tab}#{tab}expect(io.readlines.join).to eq(#{unify_cr_lf(output)})
        #{tab}end
      SPEC
    end

    def unify_cr_lf(string)
      return unless string # たまに画像で例を出してくるとsampleの文字がなくなる

      string&.gsub(/\R/, "\n")&.dump
    end

    def tab
      "\s\s"
    end
  end
end
