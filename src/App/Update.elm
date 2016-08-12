module App.Update exposing (update)

import App.Messages exposing (AppMsg (..))
import App.Models exposing (Model)

import WebReport.Main as ReportMain
import WebReport.Messages as ReportMsg
import WebReport.Update as ReportUpdate
import WebReport.Models exposing (ReportId, Report, WebUrl, Status (Fetching))

update : AppMsg -> Model -> (Model, Cmd AppMsg)
update msg model =
  case msg of
    FetchWebpagesFail error ->
      (model, Cmd.none)

    FetchReports webpages ->
      let
        (newReports, cmds) =
          List.unzip (List.map initReport webpages)
      in
        (
          { model | reports = newReports },
          Cmd.batch cmds
        )

    WebReportMsg id subMsg ->
      let
        (newReports, cmds) =
          List.unzip (List.map (updateReport id subMsg) model.reports)
      in
        (
          { model | reports = newReports },
          Cmd.batch cmds
        )

    SelectReport reportId ->
      (
        if isReportFetching model.reports reportId then model
        else { model | selected = reportId },
        Cmd.none
      )

initReport: WebUrl -> (Report, Cmd AppMsg)
initReport web =
  let
    (report, cmds) = ReportMain.init web
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

isReportFetching: List Report -> ReportId -> Bool
isReportFetching reports reportId =
  reports
    |> List.filter (\report -> report.id == reportId)
    |> List.any (\report -> report.status == Fetching)