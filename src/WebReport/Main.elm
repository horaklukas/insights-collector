module WebReport.Main exposing (init)

import Html exposing (Html)
import Html.App as App

import WebReport.Models exposing (Report, Status (..))
import WebReport.Messages exposing (Msg)
import WebReport.Commands exposing (getInsightReport)
import WebReport.Update exposing (update)
--import WebReport.View exposing (tab)

{-
main =
  App.program
    {
      init = init "",
      view = tab,
      update = update,
      subscriptions = subscriptions
    }
-}

init: String -> (Report, Cmd Msg)
init web =
  (
    Report web web Fetching 0,
    getInsightReport web
  )

-- SUBSCRIPTIONS

subscriptions : Report -> Sub Msg
subscriptions model =
    Sub.none
