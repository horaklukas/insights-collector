module App.Messages exposing (AppMsg, AppMsg (..))

import Http

import App.Models exposing (ReportId, WebUrl)
import WebReport.Messages as ReportMsg

type AppMsg =
  FetchWebpagesFail Http.Error |
  FetchReports (List WebUrl) |
  WebReportMsg ReportId ReportMsg.Msg
