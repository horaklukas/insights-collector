module Main exposing (..)

import Html exposing (Html)
import Task

import App.Models exposing (Model, initialModel)
import App.Messages exposing (AppMsg, AppMsg(..))
import App.Update exposing (update)
import App.View exposing (view)
import WebReport.Models exposing (WebUrl)

type alias Flags = {
  appVersion: String,
  webpages: List WebUrl
}

  -- INIT
init : Flags -> ( Model, Cmd AppMsg )
init flags =
  (
    initialModel flags.appVersion,
    Task.perform Webpages (Task.succeed flags.webpages)
  )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub AppMsg
subscriptions model =
    Sub.none

main: Program Flags Model AppMsg
main =
  Html.programWithFlags {
    init = init ,
    update = update,
    subscriptions = subscriptions,
    view = view
  }
