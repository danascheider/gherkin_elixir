defmodule Gherkin.Token do
  defstruct type: :GherkinDocument,
            line: nil,
            matched_keyword: "",
            matched_items: [],
            matched_text: "",
            matched_gherkin_dialect: "en",
            location: %{line: 1, column: 1},
            indent: 0

  def transform(token) do
    cond do
      Gherkin.Line.is_eof?(token.line) ->
        %{token | type: :EOF}
      Gherkin.Line.is_tags?(token.line) ->
        %{token | type: :Tags, indent: Gherkin.Line.indent(token.line), matched_items: get_tags(token.line)}
      Gherkin.Line.is_feature_header?(token.line, token.matched_gherkin_dialect) ->
        keyword = Gherkin.Dialect.feature_keywords(token.matched_gherkin_dialect)
                  |>Enum.find(fn(k) -> Gherkin.Line.starts_with?(token.line, k) end)
        text    = Gherkin.Line.get_rest_trimmed(token.line, String.length("#{keyword}:"))

        %{
          token | 
          type: :FeatureLine, 
          indent: Gherkin.Line.indent(token.line),
          matched_keyword: keyword,
          matched_text: text
        }
      Gherkin.Line.is_scenario_header?(token.line, token.matched_gherkin_dialect) ->
        keyword = Gherkin.Dialect.scenario_keywords(token.matched_gherkin_dialect)
                  |> Enum.find(fn(k) -> Gherkin.Line.starts_with?(token.line, k) end)
        text    = Gherkin.Line.get_rest_trimmed(token.line, String.length("#{keyword}:"))

        %{
          token |
          type: :ScenarioLine,
          indent: Gherkin.Line.indent(token.line),
          matched_keyword: keyword,
          matched_text: text
        }
    end
  end

  defp get_tags(line) do
    cols = get_columns(line.text, "@")

    tags = Gherkin.Line.trimmed_text(line) 
           |> String.trim_trailing 
           |> String.split(" ")
           |> Enum.zip(cols)
  end

  defp get_columns(text, character) do
    String.split(text, "")
    |> find_indices(character)
  end

  defp find_indices(list, element) do
    Enum.with_index(list)
    |> Enum.filter(fn({item, _}) -> item == element end)
    |> Enum.map(fn({_, index}) -> index + 1 end)
  end
end