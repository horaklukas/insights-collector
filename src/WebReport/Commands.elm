module WebReport.Commands exposing (getInsightReport, errorMapper)

import Http
import Json.Decode as Json
import Task

import WebReport.Messages exposing (Msg (..))

baseUrl: String
baseUrl = "https://www.googleapis.com/pagespeedonline/v2/runPagespeed?url=http%3A%2F%2F"

getInsightReport: String -> Cmd Msg
getInsightReport webname =
  let
    url = baseUrl ++ webname
    succededCallback = FetchInsightSucceed webname
  in
    Task.perform FetchInsightFail succededCallback (Http.get decodeInsight url)

decodeInsight: Json.Decoder Float
decodeInsight =
  Json.at ["ruleGroups", "SPEED", "score"] Json.float

errorMapper: Http.Error -> String
errorMapper err =
    case err of
      Http.UnexpectedPayload s -> "Payload" ++ s
      otherwise -> "http error"
