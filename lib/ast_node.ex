defmodule Gherkin.AstNode do
  defstruct rule_type: :GherkinDocument, sub_items: %{}, location: %{line: 1, column: 1}

  def add(node, child) do
    items     = Map.get(node.sub_items, child.rule_type, []) |> Enum.concat([child])
    sub_items = Map.merge(node.sub_items, %{child.rule_type => items})
    %Gherkin.AstNode{ node | sub_items: sub_items}
  end
end