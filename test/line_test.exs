defmodule GherkinLineTest do
  use ExUnit.Case
  doctest Gherkin.Line

  test ".is_comment?\\1 returns true if the line is a comment" do
    line = %Gherkin.Line{text: "# This is a comment", line_number: 14}

    assert Gherkin.Line.is_comment?(line) == true
  end

  test ".is_comment?\\1 returns false if the line is not a comment" do
    line = %Gherkin.Line{text: "Feature: Hello world", line_number: 1}

    assert Gherkin.Line.is_comment?(line) == false
  end

  test ".is_language_header?\\1 returns true if the line is a language header" do
    line = %Gherkin.Line{text: "# language: ja"}

    assert Gherkin.Line.is_language_header?(line) == true
  end

  test ".is_language_header?\\1 returns false if the line is not a language header" do
    line = %Gherkin.Line{text: "  # language is English"}

    assert Gherkin.Line.is_language_header?(line) == false
  end

  test ".is_feature_header?\\2 returns true if the line is a feature header" do
    line = %Gherkin.Line{text: "Funzionalità: Buon giorno mondo"}

    assert Gherkin.Line.is_feature_header?(line, "it") == true
  end

  test ".is_feature_header?\\2 returns true if the line is not a feature header" do
    line = %Gherkin.Line{text: "Funzionalità: Buon giorno mondo"}

    assert Gherkin.Line.is_feature_header?(line, "en") == false
  end

  test ".is_scenario_header?\\2 returns true if the line is a scenario header" do
    line = %Gherkin.Line{text: "Scenario: User logs in"}

    assert Gherkin.Line.is_scenario_header?(line, "en") == true
  end

  test ".is_scenario_header?\\2 returns false if the line is not a scenario header" do
    line = %Gherkin.Line{text: "Scénario: Login"}

    assert Gherkin.Line.is_scenario_header?(line, "en") == false
  end

  test ".is_step?\\2 returns true if the line is a step" do
    line = %Gherkin.Line{text: "Quando clicco su 'Login'"}

    assert Gherkin.Line.is_step?(line, "it") == true
  end

  test ".is_step?\\2 returns false if the line is not a step" do
    line = %Gherkin.Line{text: "# language: af"}

    assert Gherkin.Line.is_step?(line, "af") == false
  end

  test ".empty?\\1 returns true if the line is empty" do
    line = %Gherkin.Line{text: "  "}

    assert Gherkin.Line.empty?(line) == true
  end

  test ".empty?\\1 returns false if the line is not empty" do
    line = %Gherkin.Line{text: "    This line is not empty"}

    assert Gherkin.Line.empty?(line) == false
  end

  test ".is_docstring_separator?\\1 returns true if the line is a docstring separator" do
    line = %Gherkin.Line{text: "    \"\"\" "}

    assert Gherkin.Line.is_docstring_separator?(line) == true
  end

  test ".is_docstring_separator?\\1 returns true if the line is a docstring separator with backticks" do
    line = %Gherkin.Line{text: "   ``` "}

    assert Gherkin.Line.is_docstring_separator?(line) == true
  end

  test ".is_docstring_separator?\\1 returns false if the line is not a docstring separator" do
    line = %Gherkin.Line{text: " ... "}

    assert Gherkin.Line.is_docstring_separator?(line) == false
  end
end