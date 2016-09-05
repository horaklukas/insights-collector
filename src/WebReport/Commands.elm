module WebReport.Commands exposing (getInsightReport, errorMapper)

import Http
import String
import Json.Decode as Json exposing ((:=))
import Task

import WebReport.Messages exposing (Msg (..))
import WebReport.Models exposing (..)

type alias Url = String

type alias Param = (String, String)

baseUrl: Url
baseUrl = "https://www.googleapis.com/pagespeedonline/v2/runPagespeed"

getInsightReport: String -> ReportStrategy -> Cmd Msg
getInsightReport webname strategy =
  let
    succededCallback = FetchInsightSucceed webname
    url = makeUrl webname <| getStrategyName strategy
  in
    Task.perform FetchInsightFail succededCallback (Http.get decodeReport url)

makeUrl: String -> String -> Url
makeUrl webname strategy =
  let
    params = [
      ("url", "http%3A%2F%2F" ++ webname),
      ("strategy", strategy),
      ("screenshot", "true")
    ]
  in
    params
      |> List.map makeUrlParam
      |> String.join "&"
      |> String.append (baseUrl ++ "?")

makeUrlParam: Param -> String
makeUrlParam (paramName, value) =
  paramName ++ "=" ++ value

decodeReport: Json.Decoder ReportData
decodeReport =
  Json.object4 ReportData
    decodeScore
    (Json.at ["pageStats"] decodeStats)
    (Json.at ["screenshot"] decodeScreenshot)
    (Json.at ["formattedResults", "ruleResults"] decodeRules)


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

decodeScreenshot: Json.Decoder Screenshot
decodeScreenshot =
  Json.object4 Screenshot
    ("data" := Json.string)
    ("width" := Json.int)
    ("height" := Json.int)
    ("mime_type" := Json.string)

decodeRules: Json.Decoder Rules
decodeRules =
  Json.keyValuePairs decodeRule

decodeRule: Json.Decoder Rule
decodeRule =
  Json.object3 Rule
    ("localizedRuleName" := Json.string)
    (Json.maybe ("summary" := decodeSummary))
    ("ruleImpact" := Json.float)

decodeSummary: Json.Decoder RuleSummary
decodeSummary =
  Json.object2 RuleSummary
    ("format" := Json.string)
    (Json.maybe ("args" := Json.list decodeFormatArg))

decodeFormatArg: Json.Decoder FormatArg
decodeFormatArg =
  Json.object3 FormatArg
    ("type" := Json.string)
    ("key" := Json.string)
    ("value" := Json.string)

errorMapper: Http.Error -> String
errorMapper err =
    case err of
      Http.UnexpectedPayload s -> "Payload" ++ s
      otherwise -> "http error"
