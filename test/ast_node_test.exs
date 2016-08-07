defmodule AstNodeTest do
  use ExUnit.Case
  doctest Gherkin.AstNode

  test ".add adds the given item to sub-items" do
    node1 = %Gherkin.AstNode{rule_type: :GherkinDocument}
    node2 = %Gherkin.AstNode{rule_type: :FeatureHeader}

    assert Gherkin.AstNode.add(node1, node2) == %Gherkin.AstNode{ node1 | sub_items: %{:FeatureHeader => [node2]}}
  end
end