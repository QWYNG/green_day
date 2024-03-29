# frozen_string_literal: true

module GreenDay
  module TestBuilder
    module_function

    def build_test(submit_file_path, input_output_hash)
      <<~SPEC
        RSpec.describe '#{submit_file_path}' do
        #{input_output_hash.map { |input, output| build_example(submit_file_path, input, output) }.join("\n")}
        end
      SPEC
    end

    # rubocop:disable Metrics/AbcSize
    def build_example(submit_file_path, input, output)
      <<~SPEC
        #{tab}it 'test with #{unify_cr_lf(input).chomp}' do
        #{tab}#{tab}if ENV['GD_REPL']
        #{tab}#{tab}#{tab}File.chmod(0o755, '#{submit_file_path}')
        #{tab}#{tab}#{tab}system(%q(expect -c 'set timeout 2; spawn ruby #{submit_file_path}; send #{unify_cr_lf("#{input}\\004")}; interact'))
        #{tab}#{tab}else
        #{tab}#{tab}#{tab}io = IO.popen('ruby #{submit_file_path}', 'w+')
        #{tab}#{tab}#{tab}io.puts(#{unify_cr_lf(input)})
        #{tab}#{tab}#{tab}io.close_write
        #{tab}#{tab}#{tab}expect(io.readlines.join).to eq(#{unify_cr_lf(output)})
        #{tab}#{tab}end
        #{tab}end
      SPEC
    end
    # rubocop:enable Metrics/AbcSize

    def unify_cr_lf(string)
      return unless string # たまに画像で例を出してくるとsampleの文字がなくなる

      string.gsub(/\R/, "\n").dump
    end

    def tab
      "\s\s"
    end
  end
end
