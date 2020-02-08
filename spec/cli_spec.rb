# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GreenDay::Cli do
  let!(:cli) { described_class.new }

  describe 'new [contest name]' do
    # https://atcoder.jp/contests/abc150
    subject { cli.new('abc150') }

    before :example do
      subject
    end

    after :example do
      FileUtils.remove_entry_secure('abc150')
    end

    it 'create contest name dir and file for submit' do
      expect(File.exist?('abc150')).to be_truthy
      expect(File.exist?('abc150/A.rb')).to be_truthy
      expect(File.exist?('abc150/B.rb')).to be_truthy
      expect(File.exist?('abc150/C.rb')).to be_truthy
      expect(File.exist?('abc150/D.rb')).to be_truthy
      expect(File.exist?('abc150/E.rb')).to be_truthy
      expect(File.exist?('abc150/F.rb')).to be_truthy
    end

    it 'create spec file' do
      expect(File.exist?('abc150/spec')).to be_truthy
      expect(File.exist?('abc150/spec/A_spec.rb')).to be_truthy
      expect(File.exist?('abc150/spec/B_spec.rb')).to be_truthy
      expect(File.exist?('abc150/spec/C_spec.rb')).to be_truthy
      expect(File.exist?('abc150/spec/D_spec.rb')).to be_truthy
      expect(File.exist?('abc150/spec/E_spec.rb')).to be_truthy
      expect(File.exist?('abc150/spec/F_spec.rb')).to be_truthy
    end

    it 'write spec code' do
      expect(File.read('abc150/spec/A_spec.rb')).to eq(
        <<~SPEC
          require 'rspec'

          RSpec.describe 'test' do
            it 'test with "2 900\\n"' do
              io = IO.popen("ruby abc150/A.rb", "w+")
              io.puts("2 900\\n")
              expect(io.gets).to eq("Yes\\n")
            end

            it 'test with "1 501\\n"' do
              io = IO.popen("ruby abc150/A.rb", "w+")
              io.puts("1 501\\n")
              expect(io.gets).to eq("No\\n")
            end

            it 'test with "4 2000\\n"' do
              io = IO.popen("ruby abc150/A.rb", "w+")
              io.puts("4 2000\\n")
              expect(io.gets).to eq("Yes\\n")
            end

          end
        SPEC
      )
    end
  end
end
