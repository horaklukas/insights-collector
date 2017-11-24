module WebReport.Main exposing (init)

import Html exposing (Html)
-- import Html.App as App

import WebReport.Models exposing (Report, Status (..), ReportData, ReportStrategy, initialData)
import WebReport.Messages exposing (Msg)
import WebReport.Commands exposing (getInsightReport)
import WebReport.Update exposing (update)

init: String -> ReportStrategy -> (Report, Cmd Msg)
init web strategy =
  (
    Report web web Fetching initialData "",
    getInsightReport web strategy
  )

-- SUBSCRIPTIONS

subscriptions : Report -> Sub Msg
subscriptions model =
    Sub.none
