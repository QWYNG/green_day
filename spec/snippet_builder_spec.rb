# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GreenDay::SnippetBuilder do
  describe '.build' do
    it 'returns snippet string' do
      expect(described_class.build).to eq(
        <<~SNIPPET
          # gets.split.map(&:to_i)
          # readlines.map(&:chomp!).map { |e| e.split.map(&:to_i) }
        SNIPPET
      )
    end
  end
end
