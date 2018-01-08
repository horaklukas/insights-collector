module WebReport.Views.Tab exposing (view)

import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class)

import WebReport.Models exposing (Report, Status (..))
import WebReport.Messages exposing (Msg)

type alias ScoreClassName = String

view: Report -> Html Msg
view report =
  let
    (scoreClassName, scoreStatus) = getScore report
  in
    div [class scoreClassName]
      [
        span [class "score"] [ scoreStatus ],
        span [] [ text report.webpage ]
      ]

getScore: Report -> (ScoreClassName, Html Msg)
getScore {data, status} =
  case status of
    Fetching ->
        ("loading", span [class "magnify-loader"][])

    Fetched ->
      (getClassNameByScore data.score, text(toString(data.score) ++ "%" ))

    Error errMessage ->
      ("error", text("Error at report loading: " ++ errMessage))

getClassNameByScore: Float -> String
getClassNameByScore score =
  if score > 95 then "high"
  else if score > 80 then "medium"
  else "low"