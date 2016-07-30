module App.Commands exposing (fetchWebpages)

import Http
import Json.Decode as Json
import Task

import App.Messages exposing (AppMsg (..))
import App.Models exposing (WebUrl)

dbUrl: String
dbUrl = "http://localhost:4000"

fetchWebpages: Cmd AppMsg
fetchWebpages =
  let
    webpagesUrl = dbUrl ++ "/webpages"
  in
    Task.perform FetchWebpagesFail FetchReports (Http.get decodeCollection webpagesUrl)

decodeCollection: Json.Decoder (List WebUrl)
decodeCollection =
  Json.list Json.string