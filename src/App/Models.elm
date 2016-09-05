module App.Models exposing (Model, initialModel)

import WebReport.Models exposing (Report, ReportId, ReportStrategy(..))

type alias Model =
  {
    reports: List Report,
    selected: ReportId,
    strategy: ReportStrategy
  }

initialModel: Model
initialModel =
  Model [] "" Desktop
