module App.View exposing (view)

import Html exposing (Html, div, ul, li, button, text, a)
import Html.App as App
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)

import App.Models exposing (Model)
import App.Messages exposing (AppMsg (..))
import WebReport.Messages exposing (Msg (..))
import WebReport.Views.Tab as ReportTab
import WebReport.Views.Detail as ReportDetail
import WebReport.Models exposing (Report, ReportId, Status (Fetching), ReportStrategy(..))

view : Model -> Html AppMsg
view model =
  div []
    [
      div [] [
        strategySelect model,
        websList model,
        webDetail model
      ]
    ]

strategySelect: Model -> Html AppMsg
strategySelect model =
  ul [class "nav nav-tabs strategy"] [
    strategyTab Desktop "Desktop" (model.strategy == Desktop),
    strategyTab Mobile "Mobile" (model.strategy == Mobile)
  ]

strategyTab: ReportStrategy -> String -> Bool -> Html AppMsg
strategyTab strategy label isActive =
   let
      tabClasses = classList [
        ("active", isActive)
        --("disabled", model.status == Fetching)
      ]
    in
      li [tabClasses][
        a [href "#", onClick (ChangeStrategy strategy)][text label]
      ]

websList: Model -> Html AppMsg
websList {reports, selected} =
  ul [class "webs-list"] (List.map (viewReport selected) reports)


viewReport: ReportId -> Report -> Html AppMsg
viewReport selectedId model =
  let
    itemClasses = classList [
      ("list-group-item", True),
      ("active", selectedId == model.id),
      ("disabled", model.status == Fetching)
    ]
  in
    li [itemClasses, onClick (SelectReport model.id)] [
      App.map (WebReportMsg model.id) (ReportTab.view model)
    ]

webDetail: Model -> Html AppMsg
webDetail {reports, selected, strategy} =
  let
    maybeReport =
      reports
        |> List.filter (\report -> report.id == selected)
        |> List.head
  in
    case maybeReport of
      Just report ->
        App.map (WebReportMsg report.id) (ReportDetail.view report strategy)

      Nothing ->
        div [] []
