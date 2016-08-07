defmodule Gherkin.Line do
  defstruct text: "", line_number: 1

  def trimmed_text(line), do: String.trim_leading(line.text)

  def starts_with?(line, keyword), do: trimmed_text(line) |> String.starts_with?(keyword)

  def is_comment?(line), do: starts_with?(line, "#")

  def is_background_header?(line, language \\ "en") do
    match_title_line(line, Gherkin.Dialect.background_keywords(language))
  end

  def is_examples_header?(line, language \\ "en") do
    match_title_line(line, Gherkin.Dialect.examples_keywords(language))
  end

  def is_language_header?(line), do: Regex.match?(~r/\# language\: (.*)/, line.text)

  def is_feature_header?(line, language \\ "en") do
    match_title_line(line, Gherkin.Dialect.feature_keywords(language))
  end

  def is_scenario_header?(line, language \\ "en") do
    match_title_line(line, Gherkin.Dialect.scenario_keywords(language))
  end

  def is_scenario_outline_header?(line, language \\ "en") do
    match_title_line(line, Gherkin.Dialect.scenario_outline_keywords(language))
  end

  def is_step?(line, language \\ "en") do
    match_step_line(line, Gherkin.Dialect.step_keywords(language))
  end

  def empty?(line), do: trimmed_text(line) == ""

  def is_docstring_separator?(line) do
    separator = ~r/^(\"\"\")|(```)/

    Regex.match?(separator, trimmed_text(line))
  end

  defp match_title_line(line, keywords) do
    keyword = Enum.find(keywords, fn(keyword) -> starts_with?(line, "#{keyword}:") end)
    !!keyword
  end

  defp match_step_line(line, keywords) do
    !!Enum.find(keywords, fn(keyword) -> starts_with?(line, keyword) end)
  end
end