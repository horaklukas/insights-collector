module WebReport.Detail exposing (view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)

import WebReport.Models exposing (Report, Status (..))
import WebReport.Messages exposing (Msg)

view: Report -> Html Msg
view report =
  div [class "detail panel"] [
    div [class "panel-body"] [text ("Place for detail report of web " ++ report.webpage)]
  ]