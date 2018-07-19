module App.Messages exposing (AppMsg, AppMsg (..))

import WebReport.Models exposing (ReportId, WebUrl, ReportStrategy)
import WebReport.Messages as ReportMsg
import Websites.Messages as Websites
import Storage.Messages as Storage

type AppMsg =
  Webpages (List WebUrl) |
  WebReportMsg ReportId ReportMsg.Msg |
  ChangeStrategy ReportStrategy |
  WebsitesMsg Websites.Msg |
  AppStorageMsg Storage.Msg
