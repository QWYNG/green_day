# frozen_string_literal: true

module SnippetBuilder
  ARRAY_INPUT_SNIPPET = 'n = gets.split.map(&:to_i)'
  MULTIPLE_LINE_INPUT_SNIPPET = 'array = readlines.map(&:chomp!).map { |e| e.split.map(&:to_i) }'

  module_function

  def build
    constants
      .map { |snippet| '# ' + eval(snippet.to_s) }
      .join("\n") + "\n"
  end
end
