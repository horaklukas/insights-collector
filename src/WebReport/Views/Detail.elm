module WebReport.Views.Detail exposing (view)

import Html exposing (Html, div, ul, li, text, strong, h4, span)
import Html.Attributes exposing (class, width, height)
import Html.Events exposing (onClick)
import String

import WebReport.Models exposing (..)
import WebReport.Messages exposing (Msg (..))
import WebReport.Views.Screenshot as ScreenshotView
import Rules.View

view: Report -> ReportStrategy -> Html Msg
view report strategy =
  div [class <| "detail col-sm-7 col-md-8 col-lg-9 panel " ++ getStrategyName strategy] [
    div [class "panel-body grid"] [
      div [class "row"] [
        div [class "col-md-6"] [ScreenshotView.view report.data.screenshot],
        div [class "col-md-6"] [statsView report.data.pageStats],
        div [class "col-md-12"] [
          h4 [class "rules-heading"] [
            span [] [text "Impact"],
            text "Rule name"
          ],
          Rules.View.view report.data.rules report.activeRule
        ]
      ]
    ]
  ]

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
    intBytes = Result.withDefault 0 (String.toInt count)
    kBytes = intBytes // 1000
  in
    toString (kBytes) ++ " kB"