module App.Models exposing (Model, initialModel)

import WebReport.Models exposing (Report, ReportId)

type alias Model =
  {
    reports: List Report,
    selected: ReportId
  }

initialModel: Model
initialModel =
  Model [] ""
