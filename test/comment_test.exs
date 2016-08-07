defmodule CommentTest do
  use ExUnit.Case
  doctest Gherkin.Comment

  test ".get_comment\\1 returns the comment value" do
    assert Gherkin.Comment.get_comment({:str, 1, "# This is a comment"}) == %Gherkin.Comment{name: "This is a comment", location: %{line: 1, column: 1}}
  end
end