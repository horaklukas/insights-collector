module WebReport exposing (Model, init, Msg, update, view, subscriptions)
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Http
import Json.Decode as Json
import Task

main =
  Html.program
    {
      init = init "",
      view = view,
      update = update,
      subscriptions = subscriptions
    }

-- MODEL
type Status = Fetching | Fetched | Error String

type alias Model =
  {
    webpage: String,
    status: Status,
    score: Float
  }

init : String -> (Model, Cmd Msg)
init web =
  (
    Model web Fetching 0,
    getInsightReport web 
  )

-- UPDATE

type Msg = FetchInsight
  | FetchInsightSucceed String Float
  | FetchInsightFail Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update action {webpage, status, score} =
  case action of
    FetchInsight ->
      (Model webpage Fetching score, getInsightReport webpage)

    FetchInsightSucceed webname score ->
      (Model webpage Fetched score, Cmd.none)

    FetchInsightFail err ->
      (Model webpage (Error (errorMapper err)) score, Cmd.none)

-- VIEW

view: Model -> Html msg
view model =
  div []
    [
      span [] [ text (model.webpage ++ " : ") ],
      strong [] [ text ( toString(model.score) ++ "%" ) ]
    ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- HTTP

getInsightReport : String -> Cmd Msg
getInsightReport webname =
  let
    url = "https://www.googleapis.com/pagespeedonline/v2/runPagespeed?url=http%3A%2F%2F" ++ webname
    succededCallback = FetchInsightSucceed webname
  in
    Task.perform FetchInsightFail succededCallback (Http.get decodeInsight url)

decodeInsight: Json.Decoder Float
decodeInsight =
  Json.at ["ruleGroups", "SPEED", "score"] Json.float

errorMapper : Http.Error -> String
errorMapper err =
    case err of
      Http.UnexpectedPayload s -> "Payload" ++ s
      otherwise -> "http error"
