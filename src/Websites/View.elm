module Websites.View exposing(view)

import Html exposing (Html, div, input, text, button)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

import Websites.Models exposing (Model)
import Websites.Messages exposing (..)

view: Model -> Html Msg
view model =
  div [] [
    userWebsitesList model.userWebsites,
    input [ placeholder "New website url", value model.inputContent, onInput Change ] [],
    button [ onClick (AddWebsite model.inputContent) ] [ text "+" ]
  ]

userWebsitesList: List String -> Html Msg
userWebsitesList userWebsites =
  div [] (List.map userWebsite userWebsites)

userWebsite: String -> Html Msg
userWebsite website =
  div [] [ text website ]