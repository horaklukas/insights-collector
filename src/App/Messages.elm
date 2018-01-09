module App.Messages exposing (AppMsg, AppMsg (..))

import Http exposing (Error)

import WebReport.Models exposing (ReportId, WebUrl, ReportStrategy)
import WebReport.Messages as ReportMsg

type AppMsg =
  Webpages (List WebUrl) |
  WebReportMsg ReportId ReportMsg.Msg |
  SelectReport ReportId |
  ChangeStrategy ReportStrategy
