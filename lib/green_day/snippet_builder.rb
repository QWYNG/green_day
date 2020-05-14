# frozen_string_literal: true

module SnippetBuilder
  ARRAY_INPUT_SNIPPET = 'n = gets.split.map(&:to_i)'
  MULTIPLE_LINE_INPUT_SNIPPET = 'array = readlines.map(&:chomp!).map { |e| e.split.map(&:to_i) }'

  module_function

  def build
    create_snippet_file unless File.exist?('.snippet')
    read_snippet_file
  end

  def create_snippet_file
    file = File.open('.snippet', 'w')
    constants
      .map { |snippet| file.puts('# ' + eval(snippet.to_s)) }
    file.close

    # \e[32m green color
    puts "    \e[32mcreate\e[0m #{FileUtils.pwd}/.snippet"

    File.exist?('.snippet') ? true : false
  end

  def read_snippet_file
    file = File.open('.snippet', 'r')
    snippet = file.read || ''
    file.close

    snippet
  end

  private_class_method :create_snippet_file, :read_snippet_file
end
