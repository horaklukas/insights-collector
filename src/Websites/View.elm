module Websites.View exposing(view, websList)

import Html exposing (Html, div, input, text, button, li, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

import App.Messages exposing (AppMsg (..))
import App.Messages exposing (AppMsg (SelectReport))
import WebReport.Models exposing (Report, ReportId, Status (Fetching))
import WebReport.Views.Tab as ReportTab
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

websList: List Report -> ReportId -> Html AppMsg
websList reports selectedReport =
  ul [class "webs-list"] (List.map (viewReport selectedReport) reports)

viewReport: ReportId -> Report -> Html AppMsg
viewReport selectedId reportModel =
  let
    itemClasses = classList [
      ("list-group-item", True),
      ("active", selectedId == reportModel.id),
      ("disabled", reportModel.status == Fetching)
    ]
  in
    li [itemClasses, onClick (SelectReport reportModel.id)] [
      Html.map (WebReportMsg reportModel.id) (ReportTab.view reportModel)
    ]
