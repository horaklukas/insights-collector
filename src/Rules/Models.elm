module Rules.Models exposing (..)

type alias Rules = List (RuleId, Rule)

type alias RuleId = String

type alias Rule = {
  name: String,
  summary: Maybe (RuleSummary),
  impact: Float
}

type alias RuleSummary = {
  format: String,
  args: Maybe (List FormatArg)
}

type alias FormatArg = {
  argType: String,
  key: String,
  value: String
}