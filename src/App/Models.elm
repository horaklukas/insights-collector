module App.Models exposing (Model, initialModel)

import WebReport.Models exposing (Report, ReportId, ReportStrategy(..))
import Websites.Models as Websites

type alias Model =
  {
    reports: List Report,
    selected: ReportId,
    strategy: ReportStrategy,
    appVersion: String,
    websites: Websites.Model
  }

initialModel: String -> Model
initialModel appVersion =
  Model [] "" Desktop appVersion Websites.model
