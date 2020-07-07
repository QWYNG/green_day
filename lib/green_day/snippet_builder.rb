# frozen_string_literal: true

module GreenDay
  module SnippetBuilder
    ARRAY_INPUT_SNIPPET = 'gets.split.map(&:to_i)'
    MULTIPLE_LINE_INPUT_SNIPPET =
      'readlines.map(&:chomp!).map { |e| e.split.map(&:to_i) }'

    module_function

    def build
      [ARRAY_INPUT_SNIPPET, MULTIPLE_LINE_INPUT_SNIPPET]
        .map { |snippet| '# ' + snippet }
        .join("\n") + "\n"
    end
  end
end
