module WebReport.Commands exposing (getInsightReport, errorMapper)

import Http exposing (Error(..))
import String
import Json.Decode as Json exposing (..)
import Task

import WebReport.Messages exposing (Msg (..))
import WebReport.Models exposing (..)
import Rules.Models exposing (Rules, Rule, FormattedMessage, FormatArg, UrlBlock)

type alias Url = String

type alias Param = (String, String)

baseUrl: Url
baseUrl = "https://www.googleapis.com/pagespeedonline/v2/runPagespeed"

getInsightReport: String -> ReportStrategy -> Cmd Msg
getInsightReport webname strategy =
  let
    strategyName = getStrategyName strategy
    url = makeUrl webname strategyName
  in
    Http.send Insight (Http.get url decodeReport)

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
  map4 ReportData
    decodeScore
    (Json.at ["pageStats"] decodeStats)
    (Json.at ["screenshot"] decodeScreenshot)
    (Json.at ["formattedResults", "ruleResults"] decodeRules)


decodeScore: Json.Decoder Float
decodeScore =
  Json.at ["ruleGroups", "SPEED", "score"] Json.float

decodeStats: Json.Decoder PageStats
decodeStats =
  map6 PageStats
    (field "cssResponseBytes" Json.string)
    (field "htmlResponseBytes" Json.string)
    (field "imageResponseBytes" Json.string)
    (field "javascriptResponseBytes" Json.string)
    (field "numberCssResources" Json.int)
    --(field "numberHosts" Json.int)
    (field "numberJsResources" Json.int)
    --(field "numberResources" Json.int)
    --(field "numberStaticResources" Json.int)
    --(field "otherResponseBytes" Json.int)
    --(field "totalRequestBytes" Json.int)

decodeScreenshot: Json.Decoder Screenshot
decodeScreenshot =
  map4 Screenshot
    (field "data" Json.string)
    (field "width" Json.int)
    (field "height" Json.int)
    (field "mime_type" Json.string)

decodeRules: Json.Decoder Rules
decodeRules =
  Json.keyValuePairs decodeRule

decodeRule: Json.Decoder Rule
decodeRule =
  map4 Rule
    (field "localizedRuleName" Json.string)
    (Json.maybe (field "summary" decodeSummary))
    (Json.maybe (field "urlBlocks" (list decodeUrlBlock)))
    (field "ruleImpact" Json.float)

decodeSummary: Json.Decoder FormattedMessage
decodeSummary =
  map2 FormattedMessage
    (field "format" Json.string)
    (Json.maybe (field "args" (list decodeFormatArg)))

decodeFormatArg: Json.Decoder FormatArg
decodeFormatArg =
  map3 FormatArg
    (field "type" Json.string)
    (field "key" Json.string)
    (field "value" Json.string)

decodeUrlBlock: Json.Decoder UrlBlock
decodeUrlBlock =
  map2 UrlBlock
    (field "header" decodeSummary)
    (Json.maybe (field "urls" (list decodeUrl)))

decodeUrl: Json.Decoder FormattedMessage
decodeUrl =
  (field "result" decodeSummary)

errorMapper: Http.Error -> String
errorMapper err =
    case err of
      BadPayload message response -> "Payload" ++ message
      otherwise -> "http error"
