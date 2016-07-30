module WebReport.Messages exposing (Msg (..))

import Http

type Msg = Fetch
  | FetchInsightSucceed String Float
  | FetchInsightFail Http.Error
