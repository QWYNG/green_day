# frozen_string_literal: true

module SnippetBuilder
  INCREASE_STACK_SIZE_SNIPPET =
    "ENV[Z = 'RUBY_THREAD_VM_STACK_SIZE'] || exec( { Z => '50000000' },'ruby',$0)"
  MULTIPLE_LINE_INPUT_SNIPPET = 'readlines.map(&:chomp!).map { |e| e.split.map(&:to_i) }'
  ARRAY_INPUT_SNIPPET = 'gets.split.map(&:to_i)'

  module_function

  def build
    [INCREASE_STACK_SIZE_SNIPPET, MULTIPLE_LINE_INPUT_SNIPPET, ARRAY_INPUT_SNIPPET]
      .map { |snippet| '# ' + snippet }
      .join("\n") + "\n"
  end
end
