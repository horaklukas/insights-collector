
import WebReport
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import WebReport

defaultWebpages: List String
defaultWebpages =
    [
      "autovrakoviste-dipa.cz",
      "motoservisjelinek.cz",
      "fbctremosnice.4fan.cz"
    ]

main =
  App.program {
    init = init ,
    update = update,
    subscriptions = subscriptions,
    view = view
  }

-- MODEL

type alias Model =
  {
    reports : List Report,
    uid : Int
  }


type alias Report =
  {
    id : Int,
    model : WebReport.Model
  }

  -- INIT

init : ( Model, Cmd Msg )
init =
  ( Model [] 0, loadDefaults )

-- UPDATE

type Msg = AddWebpage String

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({reports, uid} as model) =
  case msg of
    AddWebpage web ->
      ({
        model | reports = reports ++ [ Report uid (WebReport.init web) ],
        uid = uid + 1
      }, Cmd.none)

loadDefaults: Cmd Msg
loadDefaults =
  Cmd.map AddWebpage defaultWebpages

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [
      --button [onClick loadDefaults] [],
      div [] (List.map viewReport model.reports)
    ]

viewReport : Report -> Html Msg
viewReport {id, model} =
  WebReport.view model

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
