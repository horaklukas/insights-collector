module Main exposing (..)

import LocalStorage
import LocalStorage.SharedTypes exposing(receiveWrapper)

import Html exposing (Html)
import Task

import App.Models exposing (Model, initialModel)
import App.Messages exposing (AppMsg, AppMsg(..))
import App.Update exposing (update)
import App.View exposing (view)
import WebReport.Models exposing (WebUrl)
import Storage.Main exposing (..)
import Storage.Messages exposing (Msg(UpdatePorts))
import Websites.Messages exposing (Msg(LoadUserWebsites))

type alias Flags = {
  appVersion: String,
  webpages: List WebUrl
}

  -- INIT
init : Flags -> ( Model, Cmd AppMsg )
init flags =
  (
    initialModel flags.appVersion,
    Cmd.batch [
      Task.perform Webpages (Task.succeed flags.webpages),
      Task.perform WebsitesMsg (Task.succeed LoadUserWebsites)
    ]
  )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub AppMsg
subscriptions model =
    let
      prefix = LocalStorage.getPrefix model.storage
    in
      Sub.map AppStorageMsg (receiveItem <| receiveWrapper UpdatePorts prefix)

main: Program Flags Model AppMsg
main =
  Html.programWithFlags {
    init = init ,
    update = update,
    subscriptions = subscriptions,
    view = view
  }
