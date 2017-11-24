module WebReport.Messages exposing (Msg (..))

import Http exposing (Error)

import WebReport.Models exposing (ReportData, ReportStrategy)
import Rules.Models exposing (RuleId)

type Msg = Fetch ReportStrategy
  | Insight (Result Error ReportData)
  | SelectRule RuleId
