module WebReport.Messages exposing (Msg (..))

import Http

import WebReport.Models exposing (ReportData, ReportStrategy)
import Rules.Models exposing (RuleId)

type Msg = Fetch ReportStrategy
  | FetchInsightSucceed String ReportData
  | FetchInsightFail Http.Error
  | SelectRule RuleId
