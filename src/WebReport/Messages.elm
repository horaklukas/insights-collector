module WebReport.Messages exposing (Msg (..))

import Http

import WebReport.Models exposing (ReportData, RuleId, ReportStrategy)

type Msg = Fetch ReportStrategy
  | FetchInsightSucceed String ReportData
  | FetchInsightFail Http.Error
  | SelectRule RuleId
