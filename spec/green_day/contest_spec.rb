# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GreenDay::Contest, :vcr do
  let(:contest_name) { 'abc150' }
  let(:contest) { described_class.new(contest_name) }

  describe '#task_sources' do
    it {
      expect(contest.task_sources).to all(be_a(GreenDay::Contest::TaskSource))
    }

    context 'when contest has many tasks' do
      # https://atcoder.jp/contests/typical90
      let(:contest_name) { 'typical90' }

      it 'creates all task sources' do
        expect(contest.task_sources.size).to eq(90)
      end
    end

    context 'when contest name contains hyphens' do
      # https://atcoder.jp/contests/math-and-algorithm
      let(:contest_name) { 'math-and-algorithm' }

      it 'creates task sources with hyphens contest' do
        task_sources = contest.task_sources
        expect(task_sources.first.contest_name).to eq('math-and-algorithm')
      end
    end
  end
end
