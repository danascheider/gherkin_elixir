defmodule Gherkin.Line do
  defstruct text: "", line_number: 1

  def trimmed_text(line), do: String.trim_leading(line.text)

  def starts_with?(line, keyword), do: trimmed_text(line) |> String.starts_with?(keyword)

  def is_comment?(line), do: starts_with?(line, "#")

  def is_language_header?(line), do: Regex.match?(~r/\# language\: (.*)/, line.text)
end