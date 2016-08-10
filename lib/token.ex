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
        transform_title_line(
          token, 
          :FeatureLine, 
          Gherkin.Dialect.feature_keywords(token.matched_gherkin_dialect)
          )
      Gherkin.Line.is_scenario_header?(token.line, token.matched_gherkin_dialect) ->
        transform_title_line(
          token,
          :ScenarioLine,
          Gherkin.Dialect.scenario_keywords(token.matched_gherkin_dialect)
          )
      Gherkin.Line.is_scenario_outline_header?(token.line, token.matched_gherkin_dialect) ->
        transform_title_line(
          token,
          :ScenarioOutlineLine,
          Gherkin.Dialect.scenario_outline_keywords(token.matched_gherkin_dialect)
          )
      Gherkin.Line.is_background_header?(token.line, token.matched_gherkin_dialect) ->
        transform_title_line(
          token,
          :BackgroundLine,
          Gherkin.Dialect.background_keywords(token.matched_gherkin_dialect)
          )
      Gherkin.Line.is_examples_header?(token.line, token.matched_gherkin_dialect) ->
        transform_title_line(
          token,
          :ExamplesLine,
          Gherkin.Dialect.examples_keywords(token.matched_gherkin_dialect)
          )
      Gherkin.Line.is_table_row?(token.line) ->
        %{token | type: :TableRow, matched_items: get_table_cells(token.line), indent: Gherkin.Line.indent(token.line) }
      Gherkin.Line.empty?(token.line) ->
        %{token | type: :Empty, indent: 0}
      Gherkin.Line.is_language_header?(token.line) ->
        language = Gherkin.Line.get_rest_trimmed(token.line, String.length("# language:"))
        %{token | type: :Language, matched_text: language}
      Gherkin.Line.is_comment?(token.line) ->
        %{token | type: :Comment, matched_text: token.line.text}
      Gherkin.Line.is_docstring_separator?(token.line) ->
        keyword = get_docstring_separator(token.line)
        indent  = Gherkin.Line.indent(token.line)
        %{token | type: :DocStringSeparator, indent: indent, matched_keyword: keyword, matched_text: Gherkin.Line.get_rest_trimmed(token.line, 3)}
      Gherkin.Line.is_step?(token.line) ->
        keyword = Gherkin.Dialect.step_keywords(token.matched_gherkin_dialect)
                  |> Enum.find(fn(k) -> Gherkin.Line.starts_with?(token.line, k) end)
        text    = Gherkin.Line.get_rest_trimmed(token.line, String.length(keyword))
        indent  = Gherkin.Line.indent(token.line) 

        %{token | type: :StepLine, matched_keyword: keyword, matched_text: text, indent: indent}
      true ->
        %{token | type: :Other, matched_text: Gherkin.Line.trimmed_text(token.line), indent: Gherkin.Line.indent(token.line)}
    end
  end

  defp get_tags(line) do
    cols = get_columns(line.text, "@")

    tags = Gherkin.Line.trimmed_text(line) 
           |> String.trim_trailing 
           |> String.split(" ")
           |> Enum.zip(cols)
  end

  defp get_table_cells(line) do
    cols  = get_columns(line.text, "|")

    cells = String.trim(line.text)
            |> String.split("|")
            |> Enum.map(fn(str) -> String.trim(str) end)
            |> Enum.filter(fn(str) -> str != "" end)
            |> Enum.zip(cols)
  end

  defp get_docstring_separator(line) do
    cond do
      Gherkin.Line.starts_with?(line, "\"\"\"") -> "\"\"\""
      Gherkin.Line.starts_with?(line, "```") -> "```"
      true -> ""
    end
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

  defp transform_title_line(token, type, keywords) do
    keyword = Enum.find(keywords, fn(k) -> Gherkin.Line.starts_with?(token.line, k) end)
    text    = Gherkin.Line.get_rest_trimmed(token.line, String.length("#{keyword}:"))

    %{
      token |
      type: type,
      indent: Gherkin.Line.indent(token.line),
      matched_keyword: keyword,
      matched_text: text,
      location: %{token.location | column: Gherkin.Line.indent(token.line) + 1}
    }
  end
end