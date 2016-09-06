module Rules.View exposing(..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)

import WebReport.Messages exposing (Msg)
import Rules.Rule as Rule
import Rules.Models exposing (RuleId, Rules, Rule)

view: Rules -> RuleId -> Html Msg
view rules activeRule =
  let
    sortedRules =
      rules
        |> List.sortWith sortRulesWithImpact
        |> List.map (Rule.view activeRule)
  in
    div [class "rules"] sortedRules

sortRulesWithImpact: (RuleId, Rule) -> (RuleId, Rule) -> Order
sortRulesWithImpact (rule1Id, rule1) (rule2Id, rule2) =
  case compare rule1.impact rule2.impact of
    LT -> GT
    EQ -> EQ
    GT -> LT