defmodule GherkinTokenTest do
  use ExUnit.Case
  doctest Gherkin.Token

  test ".transform\\1 when the token is EOF transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: nil}, location: %{line: 27, column: 1}}
    output = %{token | type: :EOF}

    assert Gherkin.Token.transform(token) == output
  end

  test ".transform\\1 when the token is tags transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: "@foo @bar"}}
    output = %{
      token |
      type: :Tags,
      matched_items: [
        {"@foo", 1},
        {"@bar", 6}
      ]
    }

    assert Gherkin.Token.transform(token) == output
  end

  test ".transform\\1 when the token is a feature header transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: "Funzionalità: Test"}, matched_gherkin_dialect: "it"}
    output = %{
      token |
      type: :FeatureLine,
      matched_keyword: "Funzionalità",
      matched_text: "Test"
    }

    assert Gherkin.Token.transform(token) == output
  end

  test ".transform\\1 when the token is a scenario header transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: "Scenario: Foo bar"}}
    output = %{
      token |
      type: :ScenarioLine,
      matched_keyword: "Scenario",
      matched_text: "Foo bar"
    }

    assert Gherkin.Token.transform(token) == output
  end

  test ".transform\\1 when the token is a scenario outline header transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: "Plan du scénario: Foo bar"}, matched_gherkin_dialect: "fr"}
    output = %{
      token |
      type: :ScenarioOutlineLine,
      matched_keyword: "Plan du scénario",
      matched_text: "Foo bar"
    }

    assert Gherkin.Token.transform(token) == output
  end

  test ".transform\\1 when the token is a background header transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: "Contesto: Qualcosa"}, matched_gherkin_dialect: "it"}
    output = %{
      token |
      type: :BackgroundLine,
      matched_keyword: "Contesto",
      matched_text: "Qualcosa"
    }

    assert Gherkin.Token.transform(token) == output
  end

  test ".transform\\1 when the token is an examples header transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: "Ejemplos:"}, matched_gherkin_dialect: "es"}
    output = %{
      token |
      type: :ExamplesLine,
      matched_keyword: "Ejemplos",
      matched_text: ""
    }

    assert Gherkin.Token.transform(token) == output
  end

  test ".transform\\1 when the token is a table row transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: "     | foo | bar | baz | "}}
    output = %{
      token |
      type: :TableRow,
      indent: 5,
      matched_items: [
        {"foo", 6},
        {"bar", 12},
        {"baz", 18}
      ]
    }

    assert Gherkin.Token.transform(token) == output
  end

  test ".transform\\1 when the token is empty transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: "  "}}
    output = %{
      token |
      type: :Empty
    }

    assert Gherkin.Token.transform(token) == output
  end

  test ".transform\\1 when the token is a language header transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: "# language: af"}}
    output = %{
      token |
      type: :Language,
      matched_text: "af"
    }

    assert Gherkin.Token.transform(token) == output
  end

  test ".transform\\1 when the token is a comment transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: "       # This is a comment   "}}
    output = %{
      token |
      type: :Comment,
      matched_text: "       # This is a comment   ",
      indent: 0
    }

    assert Gherkin.Token.transform(token) == output
  end

  test ".transform\\1 when the token is a quote docstring separator transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: "    \"\"\"json"}}
    output = %{
      token |
      type: :DocStringSeparator,
      indent: 4,
      matched_keyword: "\"\"\"",
      matched_text: "json"
    }

    assert Gherkin.Token.transform(token) == output
  end

  test ".transform\\1 when the token is a backtick docstring separator transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: "    ```"}}
    output = %{
      token |
      type: :DocStringSeparator,
      indent: 4,
      matched_keyword: "```",
      matched_text: ""
    }

    assert Gherkin.Token.transform(token) == output
  end

  test ".transform\\1 when the token is a step transforms the token" do
    token  = %Gherkin.Token{line: %Gherkin.Line{text: "    When I throw my computer out the window"}}
    output = %{
      token |
      type: :StepLine,
      indent: 4,
      matched_keyword: "When ",
      matched_text: "I throw my computer out the window"
    }

    assert Gherkin.Token.transform(token) == output
  end
end