module WebReport.Main exposing (init)

import Html exposing (Html)
import Html.App as App

import WebReport.Models exposing (Report, Status (..), ReportData, initialData)
import WebReport.Messages exposing (Msg)
import WebReport.Commands exposing (getInsightReport)
import WebReport.Update exposing (update)

init: String -> (Report, Cmd Msg)
init web =
  (
    Report web web Fetching initialData,
    getInsightReport web
  )

-- SUBSCRIPTIONS

subscriptions : Report -> Sub Msg
subscriptions model =
    Sub.none
