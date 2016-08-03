module WebReport.Tab exposing (view)

import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class)

import WebReport.Models exposing (Report, Status (..))
import WebReport.Messages exposing (Msg)

type alias ScoreClassName = String
type alias ScoreStatus = String

view: Report -> Html Msg
view report =
  let
    (scoreClassName, scoreStatus) = getScore report
  in
    div [class scoreClassName]
      [
        span [class "score"] [ text (scoreStatus) ],
        span [] [ text report.webpage ]
      ]

getScore: Report -> (ScoreClassName, ScoreStatus)
getScore {score, status} =
  case status of
    Fetching ->
        ("info", "Loading report...")

    Fetched ->
      (getClassNameByScore score, toString(score) ++ "%" )

    Error errMessage ->
      ("error", "Error at report loading" ++ errMessage)

getClassNameByScore: Float -> String
getClassNameByScore score =
  if score > 95 then "high"
  else if score > 80 then "medium"
  else "low"