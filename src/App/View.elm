module App.View exposing (view)

import Html exposing (Html, div, ul, li, button, text)
import Html.App as App
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import App.Models exposing (Model)
import App.Messages exposing (AppMsg (..))
import WebReport.Messages exposing (Msg (..))
import WebReport.Tab as ReportTab
import WebReport.Detail as ReportDetail
import WebReport.Models exposing (Report, ReportId)

view : Model -> Html AppMsg
view model =
  div []
    [
      div [] [
        websList model,
        webDetail model
      ]
    ]

websList: Model -> Html AppMsg
websList {reports, selected} =
  ul [class "webs-list"] (List.map (viewReport selected) reports)


viewReport: ReportId -> Report -> Html AppMsg
viewReport selectedId model =

  let
    itemClasses = if selectedId == model.id then "active " else ""
  in
    li [class (itemClasses ++ "list-group-item"), onClick (SelectReport model.id)] [
      App.map (WebReportMsg model.id) (ReportTab.view model)
    ]

webDetail: Model -> Html AppMsg
webDetail {reports, selected} =
  let
    maybeReport =
      reports
        |> List.filter (\report -> report.id == selected)
        |> List.head
  in
    case maybeReport of
      Just report ->
        App.map (WebReportMsg report.id) (ReportDetail.view report)

      Nothing ->
        div [] []
