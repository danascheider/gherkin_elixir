defmodule TagTest do
  use ExUnit.Case
  doctest Gherkin.Tag

  test ".get_tags\\1 returns the tags with their locations" do
    tags = "  @foo @bar"

    assert Gherkin.Tag.get_tags(tags) == [{"@foo", 3}, {"@bar", 8}]
  end
end