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
end