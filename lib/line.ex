defmodule Gherkin.Line do
  defstruct text: "", line_number: 1

  def trimmed_text(line), do: String.trim_leading(line.text)

  def starts_with?(line, keyword), do: trimmed_text(line) |> String.starts_with?(keyword)

  def is_comment?(line), do: starts_with?(line, "#")

  def is_language_header?(line), do: Regex.match?(~r/\# language\: (.*)/, line.text)

  def is_feature_header?(line, language \\ "en") do
    match_title_line(line, Gherkin.Dialect.feature_keywords(language))
  end

  def is_scenario_header?(line, language \\ "en") do
    match_title_line(line, Gherkin.Dialect.scenario_keywords(language))
  end

  defp match_title_line(line, keywords) do
    keyword = Enum.find(keywords, fn(keyword) -> starts_with?(line, "#{keyword}: ") end)
    !!keyword
  end
end