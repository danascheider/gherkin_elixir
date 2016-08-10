defmodule GherkinLexerTest do
  use ExUnit.Case
  doctest Gherkin.Lexer

  test ".tokenize\\3 tokenizes a simple Gherkin document" do
    document = "Feature: Test\n"
    output   = [
                 %Gherkin.Token{
                  type: :FeatureLine,
                  line: %Gherkin.Line{text: "Feature: Test", line_number: 1},
                  matched_keyword: "Feature",
                  matched_text: "Test",
                  location: %{line: 1, column: 1},
                 },
                 %Gherkin.Token{
                  type: :Empty,
                  line: %Gherkin.Line{text: "", line_number: 2},
                  location: %{line: 2, column: 1}
                 },
                 %Gherkin.Token{
                  type: :EOF,
                  line: %Gherkin.Line{text: nil, line_number: 3},
                  location: %{line: 3, column: 1}
                 }
               ]

    assert Gherkin.Lexer.tokenize(document, "/features/test.feature", "en") == output
  end

  test ".tokenize\\3 tokenizes a less simple Gherkin document" do
    document = "Feature: Test\n  Scenario: Foo bar\n"
    output   = [
      %Gherkin.Token{
        type: :FeatureLine,
        line: %Gherkin.Line{text: "Feature: Test", line_number: 1},
        matched_keyword: "Feature",
        matched_text: "Test",
        location: %{line: 1, column: 1}
      },
      %Gherkin.Token{
        type: :ScenarioLine,
        line: %Gherkin.Line{text: "  Scenario: Foo bar", line_number: 2},
        matched_keyword: "Scenario",
        matched_text: "Foo bar",
        indent: 2,
        location: %{line: 2, column: 3}
      },
      %Gherkin.Token{
        type: :Empty,
        line: %Gherkin.Line{text: "", line_number: 3},
        location: %{line: 3, column: 1}
      },
      %Gherkin.Token{
        type: :EOF,
        line: %Gherkin.Line{text: nil, line_number: 4},
        location: %{line: 4, column: 1}
      }
    ]

    assert Gherkin.Lexer.tokenize(document, "/features/test.feature", "en") == output
  end
end