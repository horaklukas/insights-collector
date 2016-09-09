module Rules.Models exposing (..)

type alias Rules = List (RuleId, Rule)

type alias RuleId = String

type alias Rule = {
  name: String,
  summary: Maybe (FormattedMessage),
  urlBlocks: Maybe (List UrlBlock),
  impact: Float
}

type alias FormattedMessage = {
  format: String,
  args: Maybe (List FormatArg)
}

type alias FormatArg = {
  argType: String,
  key: String,
  value: String
}

type alias UrlBlock = {
  header: FormattedMessage,
  urls: Maybe (List FormattedMessage)
}