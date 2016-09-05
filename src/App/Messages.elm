module App.Messages exposing (AppMsg, AppMsg (..))

import Http

import WebReport.Models exposing (ReportId, WebUrl, ReportStrategy)
import WebReport.Messages as ReportMsg

type AppMsg =
  FetchWebpagesFail Http.Error |
  FetchReports (List WebUrl) |
  WebReportMsg ReportId ReportMsg.Msg |
  SelectReport ReportId |
  ChangeStrategy ReportStrategy
