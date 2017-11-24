module App.Commands exposing (fetchWebpages)

import Http
import Json.Decode as Json
import Task

import App.Messages exposing (AppMsg (..))
import WebReport.Models exposing (WebUrl)

dbUrl: String
dbUrl = "http://localhost:4000"

fetchWebpages: String -> Cmd AppMsg
fetchWebpages apiUrl =
  let
    --dbUrl = parser
    webpagesUrl = apiUrl ++ "/webpages"
  in
    Http.send Webpages (Http.get webpagesUrl decodeCollection)

decodeCollection: Json.Decoder (List WebUrl)
decodeCollection =
  Json.list Json.string