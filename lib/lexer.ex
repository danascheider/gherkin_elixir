defmodule Gherkin.Lexer do
  @spec lex(binary) :: list

  def lex(str) do
    {:ok, tokens, _} = str |> to_char_list |> :en_lexer.string
    tokens
  end
end