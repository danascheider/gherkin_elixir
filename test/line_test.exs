defmodule GherkinLineTest do
  use ExUnit.Case
  doctest Gherkin.Line

  test ".is_comment? returns true if the line is a comment" do
    line = %Gherkin.Line{text: "# This is a comment", line_number: 14}

    assert Gherkin.Line.is_comment?(line) == true
  end

  test ".is_comment? returns false if the line is not a comment" do
    line = %Gherkin.Line{text: "Feature: Hello world", line_number: 1}

    assert Gherkin.Line.is_comment?(line) == false
  end

  test ".is_language_header? returns true if the line is a language header" do
    line = %Gherkin.Line{text: "# language: ja"}

    assert Gherkin.Line.is_language_header?(line) == true
  end

  test ".is_language_header? returns false if the line is not a language header" do
    line = %Gherkin.Line{text: "  # language is English"}

    assert Gherkin.Line.is_language_header?(line) == false
  end

  test ".is_feature_header? returns true if the line is a feature header" do
    line = %Gherkin.Line{text: "Funzionalità: Buon giorno mondo"}

    assert Gherkin.Line.is_feature_header?(line, "it") == true
  end

  test ".is_feature_header? returns true if the line is not a feature header" do
    line = %Gherkin.Line{text: "Funzionalità: Buon giorno mondo"}

    assert Gherkin.Line.is_feature_header?(line, "en") == false
  end

  test ".is_scenario_header? returns true if the line is a scenario header" do
    line = %Gherkin.Line{text: "Scenario: User logs in"}

    assert Gherkin.Line.is_scenario_header?(line, "en") == true
  end

  test ".is_scenario_header? returns false if the line is not a scenario header" do
    line = %Gherkin.Line{text: "Scénario: Login"}

    assert Gherkin.Line.is_scenario_header?(line, "en") == false
  end

  test ".is_step? returns true if the line is a step" do
    line = %Gherkin.Line{text: "Quando clicco su 'Login'"}

    assert Gherkin.Line.is_step?(line, "it") == true
  end
end