module App.Commands exposing (fetchWebpages)

import Http
import Json.Decode as Json
import Task
import Navigation exposing (Location)

import App.Messages exposing (AppMsg (..))
import WebReport.Models exposing (WebUrl)

urlParser : Navigation.Location -> String
urlParser location =
    if location.port_ == "3000" then "http://localhost:4000" else "."

parser : Navigation.Parser (String)
parser =
    Navigation.makeParser urlParser

fetchWebpages: Cmd AppMsg
fetchWebpages =
  let
    dbUrl = parser 
    webpagesUrl = dbUrl ++ "/webpages"
  in
    Task.perform FetchWebpagesFail FetchReports (Http.get decodeCollection webpagesUrl)

decodeCollection: Json.Decoder (List WebUrl)
decodeCollection =
  Json.list Json.string