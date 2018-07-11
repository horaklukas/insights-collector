module App.Update exposing (update)

import App.Messages exposing (AppMsg (..))
import App.Models exposing (Model)

import WebReport.Main as ReportMain
import WebReport.Messages as ReportMsg
import WebReport.Update as ReportUpdate
import WebReport.Models exposing (..)
import Websites.Update

update : AppMsg -> Model -> (Model, Cmd AppMsg)
update msg model =
  case msg of
    Webpages webpages ->
      let
        (newReports, cmds) = webpages
          |> List.map (initReport model.strategy)
          |> List.unzip
      in
        (
          { model | reports = newReports },
          Cmd.batch cmds
        )

    WebReportMsg id subMsg ->
      let
        (newReports, cmds) = model.reports
          |> List.map (updateReport id subMsg)
          |> List.unzip
      in
        (
          { model | reports = newReports },
          Cmd.batch cmds
        )
    ChangeStrategy strategy ->
      let
        (newReports, cmds) = model.reports
          |> List.map getWebPage
          |> List.map (initReport strategy)
          |> List.unzip
      in
        (
          { model | strategy = strategy,  reports = newReports },
          Cmd.batch cmds
        )

    SelectReport reportId ->
      (
        if isReportFetching model.reports reportId then model
        else { model | selected = reportId },
        Cmd.none
      )
    WebsitesMsg subMsg ->
      let
        ( updatedWebsitesModel, widgetCmd ) = Websites.Update.update subMsg model.websites
      in
        ( 
          { model | websites = updatedWebsitesModel },
          Cmd.map WebsitesMsg widgetCmd
        )


initReport: ReportStrategy -> WebUrl -> (Report, Cmd AppMsg)
initReport strategy web =
  let
    (report, cmds) = ReportMain.init web strategy
  in
    (
      report,
      Cmd.map (WebReportMsg report.id) cmds
    )

updateReport : ReportId -> ReportMsg.Msg -> Report -> ( Report, Cmd AppMsg )
updateReport id msg report =
  if report.id /= id then
    ( report, Cmd.none )

  else
    let
      ( newReport, cmds ) = ReportUpdate.update msg report
    in
      (
        newReport,
        Cmd.map (WebReportMsg id) cmds
      )

getWebPage: Report -> WebUrl
getWebPage report =
  report.webpage

isReportFetching: List Report -> ReportId -> Bool
isReportFetching reports reportId =
  reports
    |> List.filter (\report -> report.id == reportId)
    |> List.any (\report -> report.status == Fetching)