module Main exposing (..)

import Html exposing (Html)
import Html.App as App

import App.Models exposing (Report, Model, initialModel)
import App.Messages exposing (AppMsg)
import App.Update exposing (update)
import App.View exposing (view)

  -- INIT

init : ( Model, Cmd AppMsg )
init =
  (
    initialModel,
    Cmd.none
    -- TODO: Get webpages from server
  )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub AppMsg
subscriptions model =
    Sub.none

main =
  App.program {
    init = init ,
    update = update,
    subscriptions = subscriptions,
    view = view
  }
