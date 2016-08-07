defmodule TokenMatcherTest do
  use ExUnit.Case
  doctest Gherkin.TokenMatcher

  test ".match_feature_line returns true when true" do
    token = {:str, 1, "Feature: Foo bar"}

    assert Gherkin.TokenMatcher.match_feature_line(token) == true
  end

  test ".match_feature_line returns false when there is no match" do
    token = {:str, 1, "  Scenario: Foo bar"}

    assert Gherkin.TokenMatcher.match_feature_line(token) == false
  end

  test ".match_tag_line returns false when the line doesn't match" do
    token = {:str, 1, "Feature: Foo bar"}

    assert Gherkin.TokenMatcher.match_tag_line(token) == false
  end

  test ".match_tag_line returns true when true" do
    token = {:str, 1, " @foo @bar"}

    assert Gherkin.TokenMatcher.match_tag_line(token) == true
  end

  test ".match_language returns false when there is no match" do
    token = {:str, 1, "Feature: Foo bar"}

    assert Gherkin.TokenMatcher.match_language(token) == false
  end

  test ".match_language returns true when language matches" do
    token = {:str, 1, "# language: en"}

    assert Gherkin.TokenMatcher.match_language(token) == true
  end

  test ".match_comment returns false when the line is not a comment" do
    token = {:str, 1, "Feature: Foo bar"}

    assert Gherkin.TokenMatcher.match_comment(token) == false
  end

  test ".match_comment returns true when the line is a comment" do
    token = {:str, 1, "# Foo bar"}

    assert Gherkin.TokenMatcher.match_comment(token) == true
  end
end