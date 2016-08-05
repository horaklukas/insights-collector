module WebReport.Update exposing (update)

import WebReport.Models exposing (Report, Status (..))
import WebReport.Messages exposing (Msg (..))
import WebReport.Commands exposing (getInsightReport, errorMapper)

update : Msg -> Report -> (Report, Cmd Msg)
update action report =
  let
    {webpage, status, data} = report
  in
    case action of
      Fetch ->
        ({ report | data = data, status = Fetching }, getInsightReport webpage)

      FetchInsightSucceed webname data ->
        ({ report | data = data, status = Fetched }, Cmd.none)

      FetchInsightFail err ->
        ({ report | data = data, status = (Error (errorMapper err)) }, Cmd.none)