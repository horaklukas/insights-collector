module App.Models exposing (ReportId, WebUrl, Report, Model, initialModel)

import WebReport.Models as ReportModel

type alias ReportId = String

type alias WebUrl = String

type alias Report = {
  id: ReportId,
  model: ReportModel.Model
}

type alias Model =
  {
    reports : List Report
  }

initialModel: Model
initialModel =
  {
    reports = []
  }
