module WebReport.Detail exposing (view)

import Html exposing (Html, div, ul, li, text, img, strong)
import Html.Attributes exposing (class, src, width, height)
import String exposing (toInt, map)
--import  exposing (toInt)

import WebReport.Models exposing (Report, Status (..), PageStats, Screenshot)
import WebReport.Messages exposing (Msg)

view: Report -> Html Msg
view report =
  div [class "detail panel"] [
    div [class "panel-body grid"] [
      div [class "row"] [
        div [class "col-md-6"] [pageScreenshot report.data.screenshot],
        div [class "col-md-6"] [statsView report.data.pageStats]
      ]
    ]
  ]

statsView: PageStats -> Html Msg
statsView stats =
  ul [class "stats"] [
    li [] [
      strong [] [text (toString stats.numberCssResources)],
      text (" CSS files in total of "),
      strong [] [text (bytes(stats.cssResponseBytes))]

    ],
    li [] [
      strong [] [text (toString stats.numberJsResources)],
      text (" JS files in total of "),
      strong [] [text (bytes(stats.jsResponseBytes))]

    ],
    li [] [
      text ("Images total size is "),
      strong [] [text (bytes(stats.imageResponseBytes))]
    ],
    li [] [
      text ("Html total size size is "),
      strong [] [text (bytes(stats.htmlResponseBytes))]
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
