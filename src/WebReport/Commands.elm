module WebReport.Commands exposing (getInsightReport, errorMapper)

import Http
import Json.Decode as Json exposing ((:=))
import Task

import WebReport.Messages exposing (Msg (..))
import WebReport.Models exposing (ReportData, PageStats)

baseUrl: String
baseUrl = "https://www.googleapis.com/pagespeedonline/v2/runPagespeed?url=http%3A%2F%2F"

getInsightReport: String -> Cmd Msg
getInsightReport webname =
  let
    url = baseUrl ++ webname
    succededCallback = FetchInsightSucceed webname
  in
    Task.perform FetchInsightFail succededCallback (Http.get decodeReport url)

decodeReport: Json.Decoder ReportData
decodeReport =
  Json.object2 ReportData
    decodeScore
    (Json.at ["pageStats"] decodeStats)


decodeScore: Json.Decoder Float
decodeScore =
  Json.at ["ruleGroups", "SPEED", "score"] Json.float

decodeStats: Json.Decoder PageStats
decodeStats =
  Json.object6 PageStats
    ("cssResponseBytes" := Json.string)
    ("htmlResponseBytes" := Json.string)
    ("imageResponseBytes" := Json.string)
    ("javascriptResponseBytes" := Json.string)
    ("numberCssResources" := Json.int)
    --("numberHosts" := Json.int)
    ("numberJsResources" := Json.int)
    --("numberResources" := Json.int)
    --("numberStaticResources" := Json.int)
    --("otherResponseBytes" := Json.int)
    --("totalRequestBytes" := Json.int)


errorMapper: Http.Error -> String
errorMapper err =
    case err of
      Http.UnexpectedPayload s -> "Payload" ++ s
      otherwise -> "http error"
