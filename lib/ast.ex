defmodule Gherkin.Ast do
  def start_rule(stack, rule_type) do
    stack ++ [%Gherkin.AstNode{rule_type: rule_type}]
  end
end