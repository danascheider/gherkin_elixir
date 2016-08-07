defmodule Gherkin.TokenMatcher do
  def match_feature_line({_, line_number, line}) do
    Gherkin.Line.trimmed_text("#{line}") |> String.starts_with?("Feature: ")
  end

  def match_tag_line({_, line_number, line}) do
    Gherkin.Line.trimmed_text("#{line}") |> String.starts_with?("@")
  end

  def match_language({_, line_number, line}) do
    Gherkin.Line.trimmed_text("#{line}") |> String.starts_with?("# language:")
  end

  def match_comment({_, line_number, line}) do
    Gherkin.Line.trimmed_text("#{line}") |> String.starts_with?("#")
  end
end