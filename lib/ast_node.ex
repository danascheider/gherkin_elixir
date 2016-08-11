defmodule Gherkin.AstNode do
  defstruct rule_type: :GherkinDocument, sub_items: %{}

  def add(node, rule_type, item) do
    new_sub_items = if Map.has_key?(node.sub_items, rule_type) do
      %{node.sub_items | rule_type => Map.get(node.sub_items, rule_type) ++ [item]}
    else
      Map.merge(node.sub_items, %{rule_type => [item]})
    end

    %{node | sub_items: new_sub_items}
  end
end