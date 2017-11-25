module App.Models exposing (Model, initialModel)

import WebReport.Models exposing (Report, ReportId, ReportStrategy(..))

type alias Model =
  {
    reports: List Report,
    selected: ReportId,
    strategy: ReportStrategy,
    appVersion: String
  }

initialModel: String -> Model
initialModel appVersion =
  Model [] "" Desktop appVersion
