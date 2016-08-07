defmodule Gherkin.Parser do
  def parse(document_body, url) do
    tokens = Gherkin.Lexer.lex(document_body)
    state  = 0
    stack  = []

    read_and_match(state, stack, tokens)
  end

  def read_and_match(state, stack, []) do
    stack
  end

  def read_and_match(state, stack, tokens) do
    token                  = List.first(tokens)
    {new_state, new_stack} = match_token(state, stack, token)

    read_and_match(new_state, new_stack, Enum.slice(tokens, 1..-1))
  end

  defp match_token(0, stack, token = {_, line, text}) do
    cond do
      Gherkin.TokenMatcher.match_feature_line(token) ->
        col = Gherkin.Line.indent(text) + 1

        new_stack = Enum.concat(stack, [%Gherkin.AstNode{rule_type: :Feature, location: %{line: line, column: col}}])
                    |> Enum.concat([%Gherkin.AstNode{rule_type: :FeatureHeader}])

        {3, new_stack}

      Gherkin.TokenMatcher.match_tag_line(token) ->
        tags      = Gherkin.Tag.get_tags("#{text}") 
                    |> Enum.map(fn({tag, col}) -> %Gherkin.Tag{location: %{line: line, column: col}, name: tag} end)

        new_stack = Enum.concat(stack, [
                      %Gherkin.AstNode{rule_type: :Feature},
                      %Gherkin.AstNode{rule_type: :FeatureHeader},
                      %Gherkin.AstNode{rule_type: :Tags, sub_items: %{:Tag => tags}}
                    ])

        {2, new_stack}
      Gherkin.TokenMatcher.match_language(token) ->
        language  = Gherkin.Language.get_dialect("#{text}")
        
        new_stack = Enum.concat(stack, [
                      %Gherkin.AstNode{rule_type: :Feature},
                      %Gherkin.AstNode{rule_type: :FeatureHeader, sub_items: %{:Language => [%Gherkin.Language{name: language}]}}
                    ])

        {1, new_stack}
      Gherkin.TokenMatcher.match_comment(token) ->
        comment_node = %Gherkin.AstNode{rule_type: :Comment, sub_items: %{:Comment => [Gherkin.Comment.get_comment(token)]}}
        node         = Gherkin.AstNode.add(List.last(stack) || %Gherkin.AstNode{}, comment_node)

        new_stack = Enum.slice(stack, 0..-2) |> Enum.concat([node])

        {0, new_stack}
    end 
  end
end