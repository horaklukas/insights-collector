module Websites.Messages exposing (Msg, Msg(..))

import WebReport.Models exposing (ReportId, WebUrl, ReportStrategy)
import WebReport.Messages as WebReportMsgs

type Msg = 
    Change String |
    AddWebsite String |
    SelectWebsite ReportId |
    RemoveWebsite ReportId |
    TabMsg WebReportMsgs.Msg
    