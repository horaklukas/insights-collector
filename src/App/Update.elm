module App.Update exposing (update)

import App.Messages exposing (AppMsg (..))
import App.Models exposing (ReportId, Report, Model)
import WebReport.Main as ReportMain
import WebReport.Messages as ReportMsg
import WebReport.Update as ReportUpdate

update : AppMsg -> Model -> (Model, Cmd AppMsg)
update msg model =
  case msg of
    FetchAll reports ->
      let
        (newReports, cmds) =
          List.unzip (List.map initReport reports)
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

initReport: String -> (Report, Cmd AppMsg)
initReport web =
  let
    (newReport, cmds) = ReportMain.init web
    id = web
    report = Report id newReport
  in
    (
      report,
      Cmd.map (WebReportMsg id) cmds
    )

updateReport : ReportId -> ReportMsg.Msg -> Report -> ( Report, Cmd AppMsg )
updateReport id msg report =
  if report.id /= id then
    ( report, Cmd.none )

  else
    let
      ( newReport, cmds ) = ReportUpdate.update msg report.model
    in
      (
        { report | model = newReport},
        Cmd.map (WebReportMsg id) cmds
  )
