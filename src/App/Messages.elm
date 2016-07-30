module App.Messages exposing (AppMsg, AppMsg (..))

import App.Models exposing (ReportId)
import WebReport.Messages as ReportMsg

type AppMsg =
  FetchAll (List String) |
  WebReportMsg ReportId ReportMsg.Msg
