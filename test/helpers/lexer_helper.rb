module LexerHelper
  Code_imbricate_statements = %q(
if 1:
  if 2:
    print("...")
    if false:
        pass
    print("done!")
  2

print "The End"
)

  Tokens_imbricate_statements = [
    [:IF, "if"], [:NUMBER, 1],
    [:INDENT, 2],
    [:IF, "if"], [:NUMBER, 2],
    [:INDENT, 4],
    [:IDENTIFIER, "print"], ["(", "("],
    [:STRING, "..."],
    [")", ")"],
    [:NEWLINE, "\n"],
    [:IF, "if"], [:FALSE, "false"],
    [:INDENT, 6],
    [:IDENTIFIER, "pass"],
    [:DEDENT, 4], [:NEWLINE, "\n"],
    [:IDENTIFIER, "print"], ["(", "("],
    [:STRING, "done!"],
    [")", ")"],
    [:DEDENT, 2], [:NEWLINE, "\n"],
    [:NUMBER, 2],
    [:DEDENT, 0], [:NEWLINE, "\n"],
    [:NEWLINE, "\n"],
    [:IDENTIFIER, "print"], [:STRING, "The End"]
  ]

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
