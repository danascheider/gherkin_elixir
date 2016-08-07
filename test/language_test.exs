defmodule LanguageTest do
  use ExUnit.Case
  doctest Gherkin.Language

  test ".get_dialect\\1 detects the language" do
    assert Gherkin.Language.get_dialect("  # language: fr") == "fr"
  end
end