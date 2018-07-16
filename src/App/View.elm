module App.View exposing (view)

import Html exposing (Html, div, ul, li, button, text, a, h5)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)

import App.Models exposing (Model)
import App.Messages exposing (AppMsg (..))
import WebReport.Views.Tab as ReportTab
import WebReport.Views.Detail as ReportDetail
import WebReport.Models exposing (Report, ReportId, Status (Fetching), ReportStrategy(..))
import Websites.View as WebsitesView
import Websites.Models as WebsitesModels

view: Model -> Html AppMsg
view model =
  div []
    [
      div [] [
        leftPanel model,
        webDetail model
      ],
      div [class "footer"] [text ("v" ++ model.appVersion)]
    ]

leftPanel: Model -> Html AppMsg
leftPanel model =
  div [class "left-panel"] [
    strategySelect model,
    websList model,
    Html.map WebsitesMsg (WebsitesView.view model.websites)
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

isUserDefinedReport: WebsitesModels.Model -> Report -> Bool
isUserDefinedReport { userWebsites } report =
  List.member report.id userWebsites

websList: Model -> Html AppMsg
websList {reports, selected, websites} =
  let
    (userDefinedReports, staticReports) = List.partition (isUserDefinedReport websites) reports
  in
    div [] [
      ul [class "webs-list"] (List.map (viewReport selected) staticReports),
      h5 [] [ text "User reports" ],
      ul [class "webs-list"] (List.map (viewReport selected) userDefinedReports)
    ]


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
      Html.map (WebReportMsg model.id) (ReportTab.view model)
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
        Html.map (WebReportMsg report.id) (ReportDetail.view report strategy)

      Nothing ->
        div [] []
