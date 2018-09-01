module App.View exposing (view)

import Html exposing (Html, div, ul, li, button, text, a, h5)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)

import App.Models exposing (Model)
import App.Messages exposing (AppMsg (..))
import WebReport.Views.Detail as ReportDetail
import WebReport.Models exposing (Report, ReportId, Status (Fetching), ReportStrategy(..))
import Websites.View as WebsitesView
import Websites.Models as WebsitesModels

view: Model -> Html AppMsg
view model =
  div [class "container-fluid"]
    [
      div [class "content row"] [
        leftPanel model,
        webDetail model,
        div [class "content-push col-xs-12"] []
      ],
      div [class "footer row"] [
        div [class "col-xs-12"] [ text ("v" ++ model.appVersion) ]
      ]
    ]

isUserDefinedReport: WebsitesModels.Model -> Report -> Bool
isUserDefinedReport { userWebsites } report =
  List.member report.id userWebsites

leftPanel: Model -> Html AppMsg
leftPanel model =
  let
    { reports, websites, selected } = model
    (userDefinedReports, staticReports) = List.partition (isUserDefinedReport websites) reports
  in
    div [class "left-panel col-sm-5 col-md-4 col-lg-3"] [
      strategySelect model,
      Html.map WebsitesMsg (WebsitesView.websList staticReports selected websites),
      h5 [] [ text "Custom websites" ],
      Html.map WebsitesMsg (WebsitesView.websList userDefinedReports selected websites),
      Html.map WebsitesMsg (WebsitesView.view websites)
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
        div [class "col-sm-7 col-md-8 col-lg-9"] []
