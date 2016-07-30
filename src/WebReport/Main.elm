module WebReport.Main exposing (init)

import Html exposing (Html)
import Html.App as App

import WebReport.Models exposing (Model, Status (..))
import WebReport.Messages exposing (Msg)
import WebReport.Commands exposing (getInsightReport)
import WebReport.Update exposing (update)
import WebReport.View exposing (view)

main =
  App.program
    {
      init = init "",
      view = view,
      update = update,
      subscriptions = subscriptions
    }

init : String -> (Model, Cmd Msg)
init web =
  (
    Model web Fetching 0,
    getInsightReport web
  )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
