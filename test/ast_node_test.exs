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

  test ".transform\\1 transforms a :Step node with no argument" do
    ast_node = %Gherkin.AstNode{
      rule_type: :Step,
      sub_items: %{
        StepLine: [
          %Gherkin.Token{
            type: :StepLine, 
            line: %Gherkin.Line{text: "    Given foo bar", line_number: 3},
            indent: 4,
            location: %{line: 3, column: 5},
            matched_keyword: "* ", 
            matched_text: "foo bar"
          }
        ]
      }
    }

    output = %{
      type: :Step,
      location: %{line: 3, column: 5},
      keyword: "* ",
      text: "foo bar",
      argument: nil
    }

    assert Gherkin.AstNode.transform(ast_node) == output
  end

  test ".transform\\1 transforms a :Step node with a DocString argument" do
    docstring = %Gherkin.Token{
      type: :DocString,
      line: %Gherkin.Line{text: "      This is a docstring", line_number: 4},
      indent: 6,
      location: %{line: 4, column: 7},
      matched_text: "This is a docstring"
    }

    ast_node = %Gherkin.AstNode{
      rule_type: :Step,
      sub_items: %{
        StepLine: [
          %Gherkin.Token{
            type: :StepLine, 
            line: %Gherkin.Line{text: "    Given foo bar", line_number: 3},
            indent: 4,
            location: %{line: 3, column: 5},
            matched_keyword: "* ", 
            matched_text: "foo bar"
          }
        ],
        DocString: [
          docstring
        ]
      }
    }

    output = %{
      type: :Step,
      location: %{line: 3, column: 5},
      keyword: "* ",
      text: "foo bar",
      argument: docstring
    }

    assert Gherkin.AstNode.transform(ast_node) == output
  end

  test ".transform\\1 transforms a :Step node with a DataTable argument" do
    data_table = %Gherkin.Token{
      type: :DataTable,
      line: %Gherkin.Line{text: "      | This | Is | A | Table |", line_number: 4},
      indent: 6,
      location: %{line: 4, column: 7},
      matched_text: "This is a docstring"
    }

    ast_node = %Gherkin.AstNode{
      rule_type: :Step,
      sub_items: %{
        StepLine: [
          %Gherkin.Token{
            type: :StepLine, 
            line: %Gherkin.Line{text: "    Given foo bar", line_number: 3},
            indent: 4,
            location: %{line: 3, column: 5},
            matched_keyword: "* ", 
            matched_text: "foo bar"
          }
        ],
        DataTable: [
          data_table
        ]
      }
    }

    output = %{
      type: :Step,
      location: %{line: 3, column: 5},
      keyword: "* ",
      text: "foo bar",
      argument: data_table
    }

    assert Gherkin.AstNode.transform(ast_node) == output
  end
end