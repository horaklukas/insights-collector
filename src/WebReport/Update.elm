module WebReport.Update exposing (update)

import WebReport.Models exposing (Report, Status (..))
import WebReport.Messages exposing (Msg (..))
import WebReport.Commands exposing (getInsightReport, errorMapper)

update : Msg -> Report -> (Report, Cmd Msg)
update action report =
  let
    {webpage, status, score} = report
  in
    case action of
      Fetch ->
        ({ report | score = score, status = Fetching }, getInsightReport webpage)

      FetchInsightSucceed webname score ->
        ({ report | score = score, status = Fetched }, Cmd.none)

      FetchInsightFail err ->
        ({ report | score = score, status = (Error (errorMapper err)) }, Cmd.none)