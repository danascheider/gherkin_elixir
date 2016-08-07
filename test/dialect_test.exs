defmodule DialectTest do
  use ExUnit.Case
  doctest Gherkin.Dialect

  test ".for\\1 returns a struct" do
    french = %Gherkin.Dialect{
               and: ["* ", "Et que ", "Et qu'", "Et "],
               background: ["Contexte"],
               but: ["* ", "Mais que ", "Mais qu'", "Mais "],
               examples: ["Exemples"],
               feature: ["Fonctionnalité"],
               given: ["* ", "Soit ", "Etant donné que ", "Etant donné qu'", "Etant donné ", "Etant donnée ", "Etant donnés ", "Etant données ", "Étant donné que ", "Étant donné qu'", "Étant donné ", "Étant donnée ", "Étant donnés ", "Étant données "],
               name: "French",
               native: "français",
               scenario: ["Scénario"],
               scenarioOutline: ["Plan du scénario", "Plan du Scénario"],
               then: ["* ", "Alors "],
               when: ["* ", "Quand ", "Lorsque ", "Lorsqu'"]
             }

    assert Gherkin.Dialect.for("fr") == french
  end
end
