import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task
import Array

main =
  Html.program {
    init = init ,
    update = update,
    subscriptions = subscriptions,
    view = view
  }

-- MODEL

type Status = Waiting | Fetched | Error String

type alias Model =
  {
    status: Status,
    insights: List Insight
  }

type alias Insight =
  {
    webpage: String,
    score: Float
  }

-- INIT

defaultWebpages: Array.Array String
defaultWebpages =
  Array.fromList
    [
      "autovrakoviste-dipa.cz",
      "motoservisjelinek.cz",
      "fbctremosnice.4fan.cz"
    ]

init : (Model, Cmd Msg)
init =
  (Model Waiting [], fetchInsight "autovrakoviste-dipa.cz")

-- UPDATE

type Msg = --FetchInsights
  FetchInsightsSucceed String Float
  | FetchInsightsFail Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update action {insights} =
  case action of
    --FetchInsights ->
    --  (Model "" insights, fetchInsight "autovrakoviste-dipa.cz")

    FetchInsightsSucceed webname score ->
      (Model Fetched ( (Insight webname score) :: insights), Cmd.none)

    FetchInsightsFail err ->
      (Model (Error (errorMapper err)) insights, Cmd.none)

fetchInsight : String -> Cmd Msg
fetchInsight webname =
  let
    url = "https://www.googleapis.com/pagespeedonline/v2/runPagespeed?url=http%3A%2F%2F" ++ webname
    succededCallback = FetchInsightsSucceed webname
  in
    Task.perform FetchInsightsFail succededCallback (Http.get decodeInsight url)

decodeInsight: Json.Decoder Float
decodeInsight =
  Json.at ["ruleGroups", "SPEED", "score"] Json.float

errorMapper : Http.Error -> String
errorMapper err =
    case err of
      Http.UnexpectedPayload s -> "Payload" ++ s
      otherwise -> "http error"

-- VIEW

view: Model -> Html Msg
view {status, insights} =
  div []
    [
      statusView status,
      insightsListView insights
    ]

statusView: Status -> Html Msg
statusView status =
  let
    message =
      case status of
        Waiting -> "Waiting for results"
        Fetched -> "Results fetched"
        Error err -> "Error:" ++ err
  in
    span [] [text message ]

insightsListView: List Insight -> Html msg
insightsListView insights =
  div [] (List.map insightView insights)

insightView: Insight -> Html msg
insightView insight =
  div []
    [
      span [] [ text (insight.webpage ++ " : ") ],
      strong [] [ text ( toString(insight.score) ++ "%" ) ]
    ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
