defmodule GherkinAstNodeTest do
  use ExUnit.Case
  doctest Gherkin.AstNode

  test ".add\\2 adds a sub item to sub-items" do
    ast_node  = %Gherkin.AstNode{}
    token     = %Gherkin.Token{type: :FeatureLine, matched_keyword: "Feature", matched_text: "Foo", line: %Gherkin.Line{text: "Feature: Foo"}}

    assert Gherkin.AstNode.add(ast_node, :FeatureLine, token) == %{ast_node| sub_items: %{FeatureLine: [token]}}
  end

  test ".get_single\\2 gets the first sub-item with the given type" do
    ast_node = %Gherkin.AstNode{rule_type: :FeatureLine, sub_items: %{ScenarioLine: [%Gherkin.Token{type: :ScenarioLine, matched_text: "Foo"}, %Gherkin.Token{type: :ScenarioLine, matched_text: "Bar"}]}}

    assert Gherkin.AstNode.get_single(ast_node, :ScenarioLine) == %Gherkin.Token{type: :ScenarioLine, matched_text: "Foo"}
  end

  test ".get_single\\2 returns nil if there are no such sub-items" do
    ast_node = %Gherkin.AstNode{}

    assert Gherkin.AstNode.get_single(ast_node, :ScenarioLine) == nil
  end

  test ".get_items\\2 gets all the sub-items of the given type" do
    ast_node = %Gherkin.AstNode{rule_type: :FeatureLine, sub_items: %{ScenarioLine: [%Gherkin.Token{type: :ScenarioLine, matched_text: "Foo"}, %Gherkin.Token{type: :ScenarioLine, matched_text: "Bar"}]}}
    output   = [
      %Gherkin.Token{type: :ScenarioLine, matched_text: "Foo"},
      %Gherkin.Token{type: :ScenarioLine, matched_text: "Bar"}
    ]

    assert Gherkin.AstNode.get_items(ast_node, :ScenarioLine) == output
  end

  test ".get_items\\2 returns an empty array if there are no such sub-items" do
    ast_node = %Gherkin.AstNode{}

    assert Gherkin.AstNode.get_items(ast_node, :ScenarioLine) == []
  end
end