defmodule GherkinLineTest do
  use ExUnit.Case
  doctest Gherkin.Line

  test ".trimmed_text\\1 returns text without leading whitespace" do
    assert Gherkin.Line.trimmed_text("  Feature: Foo\n") == "Feature: Foo\n"
  end

  test ".trimmed_text\\1 returns text when there is no leading whitespace" do
    assert Gherkin.Line.trimmed_text("Feature: Foo\n") == "Feature: Foo\n"
  end

  test ".get_rest_trimmed\\2 returns stripped string" do
    assert Gherkin.Line.get_rest_trimmed("  Scenario: Foo bar\n", 9) == "Foo bar"
  end

  test ".indent\\1 returns the level of indent" do
    assert Gherkin.Line.indent("  Scenario: Foo bar\n") == 2
  end
end