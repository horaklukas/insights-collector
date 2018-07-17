module Websites.View exposing(view, websList)

import Html exposing (Html, div, input, text, button, li, ul, span)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onWithOptions)
import Json.Decode as Decode

import WebReport.Models exposing (Report, ReportId, Status (Fetching))
import WebReport.Views.Tab as ReportTab
import Websites.Models exposing (Model)
import Websites.Messages exposing (..)

view: Model -> Html Msg
view model =
  div [] [
    input [ placeholder "New website url", value model.inputContent, onInput Change ] [],
    button [ onClick (AddWebsite model.inputContent) ] [ text "+" ]
  ]

websList: List Report -> ReportId -> Model -> Html Msg
websList reports selectedReport model =
  ul [class "webs-list"] (List.map (viewReport selectedReport model) reports)

viewReport: ReportId -> Model -> Report -> Html Msg
viewReport selectedId model reportModel =
  let
    itemClasses = classList [
      ("list-group-item", True),
      ("active", selectedId == reportModel.id),
      ("disabled", reportModel.status == Fetching),
      ("removable", List.member reportModel.id model.userWebsites)
    ]
  in
    li [itemClasses, onClick (SelectWebsite reportModel.id)] [
      deleteButton reportModel model.userWebsites,
      Html.map TabMsg (ReportTab.view reportModel)
    ]

deleteButton: Report -> List String -> Html Msg
deleteButton report websites =
  if List.member report.id websites then
    button [ 
      class "remove-website btn btn-default btn-xs",
      title "Remove website",
      disabled (report.status == Fetching),
      onWithOptions "click" { stopPropagation = True, preventDefault = True } ( Decode.succeed (RemoveWebsite report.id) )
    ] [ 
      span [ class "glyphicon glyphicon-trash" ] []
    ]
  else
    text ""

