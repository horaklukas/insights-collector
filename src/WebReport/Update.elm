module WebReport.Update exposing (update)

import WebReport.Models exposing (Report, Status (..))
import WebReport.Messages exposing (Msg (..))
import WebReport.Commands exposing (getInsightReport, errorMapper)


update : Msg -> Report -> (Report, Cmd Msg)
update action report =
  let
    {webpage, status, data, activeRule} = report
  in
    case action of
      Fetch strategy ->
        ({ report | data = data, status = Fetching }, getInsightReport webpage strategy)

      Insight (Ok data) ->
        ({ report | data = data, status = Fetched }, Cmd.none)

      Insight (Err err) ->
        ({ report | data = data, status = (Error (errorMapper err)) }, Cmd.none)

      SelectRule ruleId ->
        ({ report | activeRule = ruleId }, Cmd.none)