defmodule GherkinTokenScannerTest do
  use ExUnit.Case
  doctest Gherkin.TokenScanner

  test ".tokenize\\3 tokenizes a simple Gherkin document" do
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

    assert Gherkin.TokenScanner.tokenize(document, "/features/test.feature", "en") == output
  end

  test ".tokenize\\3 tokenizes a less simple Gherkin document" do
    document = "Feature: Test\n\n  Scenario: Foo\n\n    This is a description\n    of the scenario\n\n    Given foo\n    When bar\n    Then baz\n"
    output   = [
      %Gherkin.Token{type: :FeatureLine, line: %Gherkin.Line{text: "Feature: Test", line_number: 1}, matched_keyword: "Feature", matched_text: "Test", location: %{line: 1, column: 1}},
      %Gherkin.Token{type: :Empty, line: %Gherkin.Line{text: "", line_number: 2}, location: %{line: 2, column: 1}},
      %Gherkin.Token{type: :ScenarioLine, line: %Gherkin.Line{text: "  Scenario: Foo", line_number: 3}, matched_keyword: "Scenario", matched_text: "Foo", location: %{line: 3, column: 3}, indent: 2},
      %Gherkin.Token{type: :Empty, line: %Gherkin.Line{text: "", line_number: 4}, location: %{line: 4, column: 1}},
      %Gherkin.Token{type: :Other, line: %Gherkin.Line{text: "    This is a description", line_number: 5}, matched_text: "This is a description", indent: 4, location: %{line: 5, column: 5}, indent: 4},
      %Gherkin.Token{type: :Other, line: %Gherkin.Line{text: "    of the scenario", line_number: 6}, matched_text: "of the scenario", location: %{line: 6, column: 5}, indent: 4},
      %Gherkin.Token{type: :Empty, line: %Gherkin.Line{text: "", line_number: 7}, location: %{line: 7, column: 1}},
      %Gherkin.Token{type: :StepLine, line: %Gherkin.Line{text: "    Given foo", line_number: 8}, location: %{line: 8, column: 5}, matched_keyword: "Given ", matched_text: "foo", indent: 4},
      %Gherkin.Token{type: :StepLine, line: %Gherkin.Line{text: "    When bar", line_number: 9}, location: %{line: 9, column: 5}, matched_keyword: "When ", matched_text: "bar", indent: 4},
      %Gherkin.Token{type: :StepLine, line: %Gherkin.Line{text: "    Then baz", line_number: 10}, location: %{line: 10, column: 5}, matched_keyword: "Then ", matched_text: "baz", indent: 4},
      %Gherkin.Token{type: :Empty, line: %Gherkin.Line{text: "", line_number: 11}, location: %{line: 11, column: 1}},
      %Gherkin.Token{type: :EOF, line: %Gherkin.Line{text: nil, line_number: 12}, location: %{line: 12, column: 1}}
    ]

    assert Gherkin.TokenScanner.tokenize(document, "/features/test.feature", "en") == output
  end
end