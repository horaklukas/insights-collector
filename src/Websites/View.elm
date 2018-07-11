module Websites.View exposing(view)

import Html exposing (Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Websites.Models exposing (Model)
import Websites.Update exposing (..)

view: Model -> Html Msg
view model =
  div [] [ 
    input [ placeholder "New website url", onInput Change ] []
  ]
