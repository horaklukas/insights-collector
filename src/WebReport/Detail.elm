module WebReport.Detail exposing (view)

import Html exposing (Html, div, ul, li, text)
import Html.Attributes exposing (class)
import String exposing (toInt)
--import  exposing (toInt)

import WebReport.Models exposing (Report, Status (..), PageStats)
import WebReport.Messages exposing (Msg)

view: Report -> Html Msg
view report =
  div [class "detail panel"] [
    div [class "panel-body"] [
      text ("Place for detail report of web " ++ report.webpage),
      statsView report.data.pageStats
    ]
  ]

statsView: PageStats -> Html Msg
statsView stats =
  ul [] [
    li [] [text ("Number of css files: " ++ toString stats.numberCssResources)],
    li [] [text ("Css response size: " ++ bytes(stats.cssResponseBytes))],
    li [] [text ("Html response size: " ++ bytes(stats.htmlResponseBytes))],
    li [] [text ("Images response size: " ++ bytes(stats.imageResponseBytes))],
    li [] [text ("Number of js files: " ++ toString stats.numberJsResources)],
    li [] [text ("Javascript response size: " ++ bytes(stats.javascriptResponseBytes))]
  ]

bytes: String -> String
bytes count =
  let
    intBytes = Result.withDefault 0 (toInt count)
    kBytes = intBytes // 1000
  in
    toString (kBytes) ++ " kB"
