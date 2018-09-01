module Rules.View exposing(..)

import Html exposing (Html, div, h4, hr, text)
import Html.Attributes exposing (class)

import WebReport.Messages exposing (Msg)
import Rules.Rule as Rule
import Rules.Models exposing (RuleId, Rules, Rule)

view: Rules -> RuleId -> Html Msg
view rules activeRule =
  let
    (incompleted, completed) =
      rules
        |> List.sortWith sortRulesWithImpact
        |> List.partition (\(ruleId, rule) -> Rule.hasImpact rule.impact)
    incompletedRules = List.map (Rule.view activeRule) incompleted
    completedRules = List.map (Rule.view activeRule) completed
  in
    div [class "rules"] (List.concat [incompletedRules, [separator], completedRules])

separator =
  div [class "rules-separator"] [
    hr [] [],
    h4 [] [text "Completed rules"]
  ]

sortRulesWithImpact: (RuleId, Rule) -> (RuleId, Rule) -> Order
sortRulesWithImpact (rule1Id, rule1) (rule2Id, rule2) =
  case compare rule1.impact rule2.impact of
    LT -> GT
    EQ -> EQ
    GT -> LT