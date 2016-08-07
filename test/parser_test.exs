defmodule ParserTest do
  use ExUnit.Case
  doctest Gherkin.Parser

  @tag :pending
  test ".parse\\2 parses a simple feature" do
    feature = "Feature: Test"

    assert Gherkin.Parser.parse(feature, "/features/test.feature") == %{
      feature: %{
        type: :Feature,
        tags: [],
        location: %{line: 1, column: 1},
        language: "en",
        keyword: "Feature",
        name: "Test",
        children: []
      },
      comments: [],
      type: :GherkinDocument
    }
  end

  test ".read_and_match\\3 when line matches feature header returns the stack" do
    tokens = Gherkin.Lexer.lex("Feature: Test")

    assert Gherkin.Parser.read_and_match(0, [], tokens) == [
      %Gherkin.AstNode{
        rule_type: :Feature
      },
      %Gherkin.AstNode{
        rule_type: :FeatureHeader
      }
    ]
  end

  test ".read_and_match\\3 when line matches tag line returns the stack" do
    tokens = Gherkin.Lexer.lex("@foo @bar")

    tags   = [
               %Gherkin.Tag{location: %{line: 1, column: 1}, name: "@foo"},
               %Gherkin.Tag{location: %{line: 1, column: 6}, name: "@bar"}
             ]

    assert Gherkin.Parser.read_and_match(0, [], tokens) == [
      %Gherkin.AstNode{rule_type: :Feature},
      %Gherkin.AstNode{rule_type: :FeatureHeader},
      %Gherkin.AstNode{rule_type: :Tags, sub_items: %{:Tag => tags}}
    ]
  end

  test ".read_and_match\\3 when line matches language header returns the stack" do
    tokens = Gherkin.Lexer.lex("# language: fr")

    assert Gherkin.Parser.read_and_match(0, [], tokens) == [
      %Gherkin.AstNode{rule_type: :Feature},
      %Gherkin.AstNode{rule_type: :FeatureHeader, sub_items: %{:Language => [%Gherkin.Language{name: "fr"}]}}
    ]
  end

  test ".read_and_match\\3 when line matches comment returns the stack" do
    tokens       = Gherkin.Lexer.lex("# This is a comment")
    comment_node = %Gherkin.AstNode{
                     rule_type: :Comment, 
                     sub_items: %{:Comment => [%Gherkin.Comment{name: "This is a comment", location: %{line: 1, column: 1}}]}
                   }

    assert Gherkin.Parser.read_and_match(0, [%Gherkin.AstNode{}], tokens) == [
      %Gherkin.AstNode{rule_type: :GherkinDocument, sub_items: %{:Comment => [comment_node]}}
    ]
  end
end