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
end