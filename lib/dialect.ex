defmodule Gherkin.Dialect do
  defstruct and: ["* ", "And "],
            background: ["Background"],
            but: ["* ", "But "],
            examples: ["Examples", "Scenarios"],
            feature: ["Feature", "Business Need", "Ability"],
            given: ["* ", "Given "],
            name: "English",
            native: "English",
            scenario: ["Scenario"],
            scenarioOutline: ["Scenario Outline", "Scenario Template"],
            then: ["* ", "Then "],
            when: ["* ", "When "]

  @dialect_path Path.expand("./lib/gherkin-languages.json")

  {_, json}     = File.read(@dialect_path)
  {_, contents} = JSON.decode(json)

  @dialects contents

  def for(dialect) do
    language = Map.get(@dialects, dialect)
               |> Enum.reduce(%{}, fn({key, val}, acc) -> Map.put(acc, String.to_atom(key), val) end)

    %Gherkin.Dialect{} |> Map.merge(language)
  end
end
