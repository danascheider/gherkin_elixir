defmodule GherkinAstTest do
  use ExUnit.Case
  doctest Gherkin.Ast

  test ".start_rule\\2 adds a new node to the stack" do
    output = [%Gherkin.AstNode{rule_type: :None}, %Gherkin.AstNode{rule_type: :Feature}]

    assert Gherkin.Ast.start_rule([%Gherkin.AstNode{rule_type: :None}], :Feature) == output
  end
end