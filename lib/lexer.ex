defmodule Gherkin.Lexer do
  def tokenize(document, _url, language \\ "en") do
    String.split(document, "\n") 
    |> Enum.with_index 
    |> Enum.map(&(get_gherkin_line(&1)))
    |> Enum.map(&(get_gherkin_token(&1, language)))
    |> Enum.map(&Gherkin.Token.transform(&1))
    |> append_eof
  end

  defp append_eof(list) do
    last_line = List.last(list).line.line_number + 1
    list ++ [(%Gherkin.Token{line: %Gherkin.Line{text: nil, line_number: last_line}, location: %{line: last_line, column: 1}} |> Gherkin.Token.transform)]
  end

  defp get_gherkin_line({line, num}) do
    %Gherkin.Line{text: line, line_number: num + 1}
  end

  defp get_gherkin_token(gherkin_line, language) do
    %Gherkin.Token{line: gherkin_line, location: %{line: gherkin_line.line_number, column: 1}, matched_gherkin_dialect: language}
  end
end