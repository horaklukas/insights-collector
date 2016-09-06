module WebReport.Views.Screenshot exposing (..)

import Html exposing (Html, div, img)
import Html.Attributes exposing (class, src, width, height)
import String

import WebReport.Models exposing (Screenshot)
import WebReport.Messages exposing (Msg)

view: Screenshot -> Html Msg
view screenshot =
  let
    imageData = String.map fixDataChar screenshot.data
  in
    div [class "screenshot"] [
      div [class "web-preview"] [
        img [src ("data:" ++ screenshot.mime ++ ";base64," ++ imageData)] []
      ]
    ]

fixDataChar: Char -> Char
fixDataChar char =
  if char == '_' then '/'
  else if char == '-' then '+'
  else char