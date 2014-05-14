#!/usr/bin/env ruby
#
# Author: Samuel El-Borai <samuel.elborai@gmail.com>
# Date: May 2014

class Lexer
  attr_accessor :tokens

  KEYWORDS = %w(def class if true false nil)

  def initialize
    @tokens = []
  end

  def tokenize(code)
    @code = code.chomp
    @tokens = []

    current_indent = 0
    indent_stack = []

    # \A: start of the string
    # [a-z]: downcase alphabet
    # [A-Z]: upcase alphabet
    # \w*: word character ([a-zA-Z0-9]), 0 times or more
    keyword_regexp = /\A([a-z]w*)/
    identifier_regexp = /\A([a-z]\w*)/
    constant_regexp = /\A([A-Z]\w*)/
    # \d+: digit character ([0-9]), 1 time or more
    number_regexp = /\A(\d+)/
    # ^: negation
    string_regexp = /\A"([^"]*)"/
    # option m: multi-line mode
    indent_regexp = /\A\:( *)\n( +)/m
    dedent_regexp = /\A *\n( +)/m

    i = 0
    while i < @code.size
      @matcher, @m = nil, nil
      @chunk = @code[i..-1]

      if (n keyword_regexp) && KEYWORDS.include?(@m)
        # Push something like [:IF, "if"] at the end of `tokens`
        @tokens.push [@m.upcase.to_sym, @m]
      elsif n(identifier_regexp)
        @tokens.push [:IDENTIFIER, @m]
      elsif n(constant_regexp)
        @tokens.push [:CONSTANT, @m]
      elsif n(number_regexp)
        @tokens.push [:NUMBER, @m]
      elsif n(string_regexp)
        @tokens.push [:STRING, @m]
        # Skip two more chars to exclude `"`
        i += 2
      elsif n(indent_regexp) && @matcher.size > 1
        indent = @matcher[2]
        if indent.size <= current_indent
          fail error i, "Bad indent level, got #{indent.size} indents, \
expected less than #{current_indent}"
        end

        current_indent = indent.size
        indent_stack.push current_indent
        @tokens.push [:INDENT, indent.size]
        # Skip two chars to exclude `:` and `\n`
        i += 2
      elsif n(dedent_regexp)
        if @m.size == current_indent
          @tokens.push [:NEWLINE, "\n"]
        elsif @m.size < current_indent
          while @m.size < current_indent
            indent_stack.pop
            current_indent = indent_stack.last || 0
            @tokens.push [:DEDENT, @m.size]
          end
          @tokens.push [:NEWLINE, "\n"]
        else
          fail error i, 'Missing a semicolon, cannot increase indent level without one'
        end
        # Skip `\n`
        i += 1
      end

      i += @m && !@m.empty? ? @m.size : 1
    end
  end

  private

  # Get next chunk
  def n(regexp)
    @matcher = @chunk.match(regexp)
    @m = @matcher.nil? ? nil :
      (@matcher.size > 0 ? @matcher[1] : @matcher[0])
  end

  def error(char_number, message)
    line_p, char_p, line, char = get_position(char_number)
    char_int = char.ord
    char_oct, char_hex = char.ord.to_s(8), char.ord.to_s(16)
    %Q(#{message}.
Error at line: #{line_p}, char: #{char_p}
------ line: ------
#{line.gsub("\n", "\\n")}
------ char: ------
#{char}, #{char_int}, #{char_oct}, #{char_hex})
  end

  def get_position(char_number)
    line_position = 1
    line = ''
    char_position = 1
    char = ''

    @code.lines.each_with_index do |l, index|
      if char_number > l.size
        char_number -= l.size
      else
        line_position += index
        line = l
        char_position += char_number
        char = l[char_number]
        break
      end
    end

    [line_position, char_position, line, char]
  end
end
