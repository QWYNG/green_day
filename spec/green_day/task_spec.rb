# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GreenDay::Task do
  describe '#create_file' do
    context 'when template file exists' do
      before do
        FileUtils.makedirs('contest_name')
        File.write(GreenDay::TEMPLATE_FILE_PATH, 'template')
      end

      after do
        File.delete(GreenDay::TEMPLATE_FILE_PATH)
        FileUtils.remove_dir('contest_name')
      end

      it 'creates a file with the template' do
        task = described_class.new('name', 'path', 'contest_name')
        task.create_file

        expect(File.read(task.file_name)).to eq('template')
      end
    end

    context 'when template file does not exist' do
      before do
        FileUtils.makedirs('contest_name')
      end

      after do
        FileUtils.remove_dir('contest_name')
      end

      it 'creates a file' do
        task = described_class.new('name', 'path', 'contest_name')
        task.create_file

        expect(File).to exist(task.file_name)
      end
    end
  end
end
