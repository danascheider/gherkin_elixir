defmodule Gherkin.Line do
  def trimmed_text(line) do
    String.trim_leading("#{line}")
  end

  def get_rest_trimmed(line, index) do 
    text = trimmed_text(line)
    String.slice(text, index..String.length(text) - 1) |> String.trim
  end

  def indent(line) do
    String.length("#{line}") - String.length(trimmed_text(line))
  end
end