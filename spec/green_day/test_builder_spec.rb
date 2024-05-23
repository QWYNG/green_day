# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GreenDay::TestBuilder do
  let(:submit_file_path) { 'submit_file' }

  describe '.build_example' do
    subject { described_class.build_example(submit_file_path, input, output) }

    let(:input) { "2 900\n" }
    let(:output) { "Yes\n" }

    it {
      expect(subject).to eq(
        <<~SPEC
          \s\sit 'test with "2 900\\n"' do
          \s\s\s\sio = IO.popen('ruby submit_file', 'w+')
          \s\s\s\sio.puts("2 900\\n")
          \s\s\s\sio.close_write
          \s\s\s\sexpect(io.readlines.join).to eq("Yes\\n")
          \s\send
        SPEC
      )
    }
  end

  describe '.build_test' do
    subject { described_class.build_test(submit_file_path, sample_answers) }

    let(:sample_answers) do
      [GreenDay::Task::SampleAnswer.new("2 900\n", "Yes\n"),
       GreenDay::Task::SampleAnswer.new("3 900\n", "No\n")]
    end

    it {
      expect(subject).to eq(
        <<~SPEC
          RSpec.describe 'submit_file' do
          \s\sit 'test with "2 900\\n"' do
          \s\s\s\sio = IO.popen('ruby submit_file', 'w+')
          \s\s\s\sio.puts("2 900\\n")
          \s\s\s\sio.close_write
          \s\s\s\sexpect(io.readlines.join).to eq("Yes\\n")
          \s\send

          \s\sit 'test with "3 900\\n"' do
          \s\s\s\sio = IO.popen('ruby submit_file', 'w+')
          \s\s\s\sio.puts("3 900\\n")
          \s\s\s\sio.close_write
          \s\s\s\sexpect(io.readlines.join).to eq("No\\n")
          \s\send

          end
        SPEC
      )
    }
  end
end
