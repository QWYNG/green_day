# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GreenDay::Cli, vcr: true do
  let!(:cli) { described_class.new }

  describe 'new [contest name]' do
    subject { cli.new(contest_name) }

    # https://atcoder.jp/contests/abc150
    let(:contest_name) { 'abc150' }

    before do
      subject
    end

    after do
      FileUtils.remove_entry_secure(contest_name)
    end

    it 'creates contest name dir and file for submit' do
      aggregate_failures do
        expect(File).to exist('abc150/A.rb')
        expect(File).to exist('abc150/B.rb')
        expect(File).to exist('abc150/C.rb')
        expect(File).to exist('abc150/D.rb')
        expect(File).to exist('abc150/E.rb')
        expect(File).to exist('abc150/F.rb')
      end
    end

    it 'creates spec file' do
      aggregate_failures do
        expect(File).to exist('abc150/spec/A_spec.rb')
        expect(File).to exist('abc150/spec/B_spec.rb')
        expect(File).to exist('abc150/spec/C_spec.rb')
        expect(File).to exist('abc150/spec/D_spec.rb')
        expect(File).to exist('abc150/spec/E_spec.rb')
        expect(File).to exist('abc150/spec/F_spec.rb')
      end
    end

    it 'writes spec code' do
      expect(File.read('abc150/spec/A_spec.rb')).to eq(
        <<~SPEC
          RSpec.describe 'test' do
            it 'test with "2 900\\n"' do
              io = IO.popen("ruby abc150/A.rb", "w+")
              io.puts("2 900\\n")
              io.close_write
              expect(io.readlines.join).to eq("Yes\\n")
            end

            it 'test with "1 501\\n"' do
              io = IO.popen("ruby abc150/A.rb", "w+")
              io.puts("1 501\\n")
              io.close_write
              expect(io.readlines.join).to eq("No\\n")
            end

            it 'test with "4 2000\\n"' do
              io = IO.popen("ruby abc150/A.rb", "w+")
              io.puts("4 2000\\n")
              io.close_write
              expect(io.readlines.join).to eq("Yes\\n")
            end

          end
        SPEC
      )
    end

    context 'when contest with more tasks than 001 to 090' do
      # https://atcoder.jp/contests/typical90
      let(:contest_name) { 'typical90' }

      it 'creates tasks until final task' do
        # CL is final task code of typical90
        expected_files = ('001'..'090').map { |code| "#{code}.rb" }
        expect(Dir.children('typical90') - ['spec']).to match_array(expected_files)
      end
    end

    context 'when contest name contains hyphens' do
      # https://atcoder.jp/contests/math-and-algorithm
      let(:contest_name) { 'math-and-algorithm' }

      it "task url is correct" do
        expect(File.read('math-and-algorithm/spec/001_spec.rb')).to match(/expect/)
      end
    end
  end

  describe 'login' do
    subject { cli.login }

    before do
      allow($stdin).to receive(:gets) do
        inputs.shift
      end
    end

    after do
      FileUtils.remove(GreenDay::AtcoderClient::COOKIE_FILE_NAME, force: true)
    end

    context 'with valid name and password' do
      let(:inputs) { %w[valid_name valid_password] }

      it 'creates cookie-store' do
        subject

        expect(File).to exist('.cookie-store')
      end
    end

    context 'with invalid name and password' do
      let(:inputs) { %w[invalid_name invalid_password] }

      it 'raises error' do
        expect { subject }.to raise_error(GreenDay::Error)
      end
    end
  end
end
