module Websites.Messages exposing (Msg, Msg(..))

import WebReport.Models exposing (ReportId, WebUrl, ReportStrategy)
import WebReport.Messages as WebReportMsgs

import Storage.Messages as Storage

type Msg = 
    Change String |
    AddWebsite String |
    SelectWebsite ReportId |
    RemoveWebsite ReportId |
    TabMsg WebReportMsgs.Msg |
    StorageMsg Storage.Msg
    