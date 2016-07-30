module WebReport.Update exposing (update)

import WebReport.Models exposing (Model, Status (..))
import WebReport.Messages exposing (Msg (..))
import WebReport.Commands exposing (getInsightReport, errorMapper)


update : Msg -> Model -> (Model, Cmd Msg)
update action {webpage, status, score} =
  case action of
    Fetch ->
      (Model webpage Fetching score, getInsightReport webpage)

    FetchInsightSucceed webname score ->
      (Model webpage Fetched score, Cmd.none)

    FetchInsightFail err ->
      (Model webpage (Error (errorMapper err)) score, Cmd.none)
