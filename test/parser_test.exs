defmodule GherkinParserTest do
  use ExUnit.Case
  doctest Gherkin.Parser 

  test "start_rule adds a node to the stack" do
    expected_output = [%Gherkin.AstNode{rule_type: :GherkinDocument}]

    assert Gherkin.Parser.start_rule([], :GherkinDocument) == expected_output
  end
end