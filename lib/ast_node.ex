defmodule Gherkin.AstNode do
  defstruct rule_type: :GherkinDocument, sub_items: %{}

  def add(ast_node, rule_type, item) do
    new_sub_items = if Map.has_key?(ast_node.sub_items, rule_type) do
      %{ast_node.sub_items | rule_type => Map.get(ast_node.sub_items, rule_type) ++ [item]}
    else
      Map.merge(ast_node.sub_items, %{rule_type => [item]})
    end

    %{ast_node | sub_items: new_sub_items}
  end

  def get_single(ast_node, rule_type) do
    Map.get(ast_node.sub_items, rule_type, []) |> List.first
  end

  def get_items(ast_node, rule_type) do
    Map.get(ast_node.sub_items, rule_type, [])
  end

  def transform(ast_node) do
    transform(ast_node, ast_node.rule_type)
  end

  def transform(ast_node, :Step) do
    step_line     = get_single(ast_node, :StepLine)
    step_argument = get_single(ast_node, :DocString)

    %{
      type: :Step,
      location: step_line.location,
      keyword: step_line.matched_keyword,
      text: step_line.matched_text,
      argument: step_argument
    }
  end
end