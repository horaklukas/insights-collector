module WebReport.Detail exposing (view)

import Html exposing (Html, div, ul, li, text, img, strong, h3, h4, p, span)
import Html.Attributes exposing (class, src, width, height, style)
import Html.Events exposing (onClick)
import String exposing (toInt, map)
import Regex exposing (replace, regex, HowMany (..))

import WebReport.Models exposing (..)
import WebReport.Messages exposing (Msg (..))

view: Report -> Html Msg
view report =
  let
    sortedRules =
      report.data.rules
        |> List.sortWith sortRulesWithImpact
        |> List.map (ruleView report.activeRule)
  in
    div [class "detail panel"] [
      div [class "panel-body grid"] [
        div [class "row"] [
          div [class "col-md-6"] [pageScreenshot report.data.screenshot],
          div [class "col-md-6"] [statsView report.data.pageStats],
          div [class "col-md-12"] [
            h4 [class "rules-heading"] [
              span [] [text "Impact"],
              text "Rule name"
            ],
            div [class "rules"] sortedRules
          ]
        ]
      ]
    ]

sortRulesWithImpact: (RuleId, Rule) -> (RuleId, Rule) -> Order
sortRulesWithImpact (rule1Id, rule1) (rule2Id, rule2) =
  case compare rule1.impact rule2.impact of
    LT -> GT
    EQ -> EQ
    GT -> LT

statsView: PageStats -> Html Msg
statsView stats =
  ul [class "stats"] [
    li [] [
      strong [] [text <| toString stats.numberCssResources],
      text (" CSS files in total of "),
      strong [] [text <| bytes stats.cssResponseBytes]

    ],
    li [] [
      strong [] [text <| toString stats.numberJsResources],
      text (" JS files in total of "),
      strong [] [text <| bytes stats.jsResponseBytes]

    ],
    li [] [
      text ("Images total size is "),
      strong [] [text <| bytes stats.imageResponseBytes]
    ],
    li [] [
      text ("Html total size size is "),
      strong [] [text <| bytes stats.htmlResponseBytes]
    ]
  ]

bytes: String -> String
bytes count =
  let
    intBytes = Result.withDefault 0 (toInt count)
    kBytes = intBytes // 1000
  in
    toString (kBytes) ++ " kB"

pageScreenshot: Screenshot -> Html Msg
pageScreenshot screenshot =
  let
    imageData = map fixScreenshotDataChar screenshot.data
  in
    div [class "screenshot ntb"] [
      div [class "web-preview"] [
        img [src ("data:" ++ screenshot.mime ++ ";base64," ++ imageData)] []
      ]
    ]

fixScreenshotDataChar: Char -> Char
fixScreenshotDataChar char =
  if char == '_' then '/'
  else if char == '-' then '+'
  else char

ruleView: RuleId -> (RuleId, Rule) -> Html Msg
ruleView activeRule (id, rule) =
  let
    activeClass = if activeRule == id then " expanded" else " collapsed"
  in
    div [class ("panel panel-default rule" ++ activeClass), onClick (SelectRule id)] [
      div [class "panel-heading"] [
        h4 [class "panel-title"] [
          span [class "badge"] [text <| toString <| round rule.impact],
          text rule.name
        ]
      ],
      div [class "panel-body"] [text (makeRuleSummary rule.summary)]
    ]

makeRuleSummary: RuleSummary -> String
makeRuleSummary summary =
  case summary.args of
    Just args ->
      List.foldl fillFormatArg summary.format args

    Nothing ->
      summary.format

fillFormatArg: FormatArg -> String -> String
fillFormatArg {argType, key, value} format =
  if argType == "HYPERLINK" then
    replace All (regex "{{BEGIN_LINK}}|{{END_LINK}}") (\_ -> "") format
  else
    replace All (regex <| "{{" ++ key ++ "}}") (\_ -> value) format