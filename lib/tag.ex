defmodule Gherkin.Tag do
  defstruct location: %{line: 1, column: 1}, name: ""
  
  def get_tags(line) do
    codepoints = String.codepoints(line) |> Enum.with_index
    columns    = Enum.reduce(codepoints, [], &(store_index(&1, &2)))

    Gherkin.Line.trimmed_text(line) |> String.split(" ") |> Enum.zip(columns)
  end

  defp store_index({"@", index}, acc), do: acc ++ [index + 1] # Add 1 bc columns are indexed at 1 not 0
  defp store_index({_, _}, acc), do: acc
end