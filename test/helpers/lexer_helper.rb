module LexerHelper
  Code_class_with_method = %q(
class Animal:
  def eat:
    "*crunch* *crunch*"
)

  Tokens_class_with_method = [
    [:IDENTIFIER, "class"],
    [:CONSTANT, "Animal"],
    [:INDENT, 2],
    [:IDENTIFIER, "def"],
    [:IDENTIFIER, "eat"],
    [:INDENT, 4],
    [:STRING, "*crunch* *crunch*"],
    [:DEDENT, 2],
    [:DEDENT, 0]]

  Tokens_operator_braces = [
    [:"(", "("],
    [:"[", "["],
    [:"{", "{"],
    [:IDENTIFIER, "variable"],
    [:"}", "}"],
    [:"]", "]"],
    [:")", ")"]
  ]

  Tokens_operator_conditionals = [
    [:"||", "||"],
    [:"&&", "&&"],
    [:==, "=="],
    [:!=, "!="],
    [:<=, "<="],
    [:>=, ">="]
  ]
end
