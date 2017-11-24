module Main exposing (..)

import Html exposing (Html)
-- import Html.App as App

import App.Models exposing (Model, initialModel)
import App.Messages exposing (AppMsg)
import App.Commands exposing (fetchWebpages)
import App.Update exposing (update)
import App.View exposing (view)

type alias Flags = {
  apiUrl: String
}

  -- INIT
init : Flags -> ( Model, Cmd AppMsg )
init flags =
  (
    initialModel,
    fetchWebpages flags.apiUrl
  )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub AppMsg
subscriptions model =
    Sub.none

main =
  Html.programWithFlags {
    init = init ,
    update = update,
    subscriptions = subscriptions,
    view = view
  }
