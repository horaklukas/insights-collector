module WebReport.View exposing (view)

import Html exposing (Html, div, span, strong, text)

import WebReport.Models exposing (Model, Status (..))
import WebReport.Messages exposing (Msg)

view: Model -> Html Msg
view model =
  div []
    [
      span [] [ text (model.webpage ++ " : ") ],
      strong [] [ text (getScore model) ]
    ]

getScore: Model -> String
getScore {score, status} =
  case status of
    Fetching ->
        "Loading report..."

    Fetched ->
      ( toString(score) ++ "%" )

    Error errMessage ->
      "Error at report loading" ++ errMessage
