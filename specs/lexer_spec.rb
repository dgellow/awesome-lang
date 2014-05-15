# -*- coding: utf-8 -*-
$:.unshift File.expand_path(File.dirname(__FILE__) + '/helpers')

require 'minitest/autorun'
require 'lexer'
require 'lexer_helper'

class TestLexer < Minitest::Unit::TestCase
  def setup
    @lexer = Lexer.new
  end

  def teardown
    @lexer = nil
  end


  # Keywords
  def test_keyword_def
    tokens = @lexer.tokenize '   def   '
    assert_equal tokens, [[:IDENTIFIER, 'def']]
  end

  def test_keyword_class
    tokens = @lexer.tokenize '   class   '
    assert_equal tokens, [[:IDENTIFIER, 'class']]
  end

  def test_keyword_if
    tokens = @lexer.tokenize '   if   '
    assert_equal tokens, [[:IDENTIFIER, 'if']]
  end

  def test_keyword_true
    tokens = @lexer.tokenize '   true   '
    assert_equal tokens, [[:IDENTIFIER, 'true']]
  end

  def test_keyword_false
    tokens = @lexer.tokenize '   false   '
    assert_equal tokens, [[:IDENTIFIER, 'false']]
  end

  def test_keyword_nil
    tokens = @lexer.tokenize '   nil   '
    assert_equal tokens, [[:IDENTIFIER, 'nil']]
  end


  # Identifiers
  def test_identifier
    tokens = @lexer.tokenize '   variable_12345   '
    assert_equal tokens, [[:IDENTIFIER, 'variable_12345']]
  end

  def test_identifier_with_unicode
    tokens = @lexer.tokenize '   variable_ÆẞÐĲ  '
    assert_equal tokens, [[:IDENTIFIER, 'variable_ÆẞÐĲ']]
  end

  def test_identifier_with_invalid_name
    skip 'behavior to be defined'
    tokens = @lexer.tokenize '   12345_variable   '
  end


  # Constants
  def test_constant
    tokens = @lexer.tokenize '   Person   '
    assert_equal tokens, [[:CONSTANT, 'Person']]
  end

  def test_constant_caps
    tokens = @lexer.tokenize '   KEYWORDS   '
    assert_equal tokens, [[:CONSTANT, 'KEYWORDS']]
  end


  # Numbers
  def test_number
    tokens = @lexer.tokenize '   12345   '
    assert_equal tokens, [[:NUMBER, '12345']]
  end

  def test_number_with_decimal
    tokens = @lexer.tokenize '   1234.5   '
    assert_equal tokens, [[:NUMBER, '1234.5']]
  end


  # Strings
  def test_string
    tokens = @lexer.tokenize '   "a string"   '
    assert_equal tokens, [[:STRING, 'a string']]
  end

  def test_string_with_escaped_quotes
    tokens = @lexer.tokenize '   "a \" string"   '
    assert_equal tokens, [[:STRING, "a \" string"]]
  end


  # Indents
  def test_indent_simple_case
    tokens = @lexer.tokenize LexerHelper::Code_class_with_method
    assert_equal tokens, LexerHelper::Tokens_class_with_method
  end

  def test_indent_difficult_case
    skip 'to be defined'
  end

  def test_dedent_simple_case
    skip
  end


  # Operators
  def test_operator_parentheses
    tokens = @lexer.tokenize '   ( variable )  '
    assert_equal tokens, [[:'(', '('], [:IDENTIFIER, 'variable'], [:')', ')']]
  end

  def test_operator_maths
    tokens = @lexer.tokenize '+ - / * %'
    assert_equal tokens, [[:+, '+'], [:-, '-'], [:'/', '/'], [:*, '*'], [:%, '%']]
  end
end
