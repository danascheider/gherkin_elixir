defmodule GherkinAstNodeTest do
  use ExUnit.Case
  doctest Gherkin.AstNode

  test ".add\\2 adds a sub item to sub-items" do
    node  = %Gherkin.AstNode{}
    token = %Gherkin.Token{type: :FeatureLine, matched_keyword: "Feature", matched_text: "Foo", line: %Gherkin.Line{text: "Feature: Foo"}}

    assert Gherkin.AstNode.add(node, :FeatureLine, token) == %{node| sub_items: %{FeatureLine: [token]}}
  end
end