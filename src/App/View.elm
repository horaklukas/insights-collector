module App.View exposing (view)

import Html exposing (Html, div, button, text)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import App.Models exposing (Report, Model)
import App.Messages exposing (AppMsg (..))
import WebReport.View as ReportView
import WebReport.Messages exposing (Msg)

view : Model -> Html AppMsg
view model =
  div []
    [
      div [] (List.map viewReport model.reports)
    ]


--  App.map (SubMsg id) (Gif.view model)

viewReport: Report -> Html AppMsg
viewReport {id, model} =
  App.map (WebReportMsg id) (ReportView.view model)
