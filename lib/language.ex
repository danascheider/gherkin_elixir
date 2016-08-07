defmodule Gherkin.Language do
  defstruct name: "en"

  def get_dialect(line) do
    Gherkin.Line.trimmed_text(line) |> String.split(" ") |> List.last
  end
end