defmodule Gherkin.Comment do
  defstruct name: "", location: %{line: 1, column: 1}

  def get_comment({_, line_number, line}) do
    text     = Gherkin.Line.trimmed_text("#{line}")
    location = %{line: line_number, column: String.length("#{line}") - String.length(text) + 1}
    name     = Gherkin.Line.trimmed_text(text) |> String.replace_leading("#", "") |> Gherkin.Line.trimmed_text
    
    %Gherkin.Comment{name: name, location: location}
  end
end