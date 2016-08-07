Definitions.

FEATURE             = Feature\:\s
TAGS                = (\@[^\s\r\t\n]*\s?)*
SCENARIO_OUTLINE    = Scenario\sOutline\:\s
SCENARIO            = Scenario\:\s
EXAMPLES            = Examples\:\s
SCENARIO_LINE       = (Given|When|Then|And|But)\s
LANGUAGE_HEADER     = \#\slanguage:\s[a-z]{2}
DOCSTRING_SEPARATOR = (\"\"\"|```)
NEWLINE             = [\n]
TEXT_LINE           = [^\n]

% " % This makes the editor stop thinking all this code is quoted text

Rules.

{FEATURE}           : {token, {str, TokenLine, TokenChars}}.
{TAGS}              : {token, {str, TokenLine, TokenChars}}.
{LANGUAGE_HEADER}   : {token, {str, TokenLine, TokenChars}}.
{SCENARIO_OUTLINE}  : {token, {str, TokenLine, TokenChars}}.
{SCENARIO}          : {token, {str, TokenLine, TokenChars}}.
{SCENARIO_LINE}     : {token, {str, TokenLine, TokenChars}}.
{TEXT_LINE}+        : {token, {str, TokenLine, TokenChars}}.
{NEWLINE}+          : skip_token.

% "# language: en\n@foo @bar\nFeature: Foo bar\n  Scenario: Bar baz\n    Given I am writing a test\n    When I finish writing the test\n  Scenario Outline: Baz qux"

Erlang code.