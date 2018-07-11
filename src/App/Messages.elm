module App.Messages exposing (AppMsg, AppMsg (..))

import WebReport.Models exposing (ReportId, WebUrl, ReportStrategy)
import WebReport.Messages as ReportMsg
import Websites.Messages as Websites

type AppMsg =
  Webpages (List WebUrl) |
  WebReportMsg ReportId ReportMsg.Msg |
  SelectReport ReportId |
  ChangeStrategy ReportStrategy |
  WebsitesMsg Websites.Msg
