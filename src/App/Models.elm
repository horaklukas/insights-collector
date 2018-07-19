module App.Models exposing (Model, initialModel)

import LocalStorage exposing (LocalStorage)

import WebReport.Models exposing (Report, ReportId, ReportStrategy(..))
import Websites.Models as Websites

import Storage.Main exposing (createStorage)
import Storage.Messages as Storage

type alias Model =
  {
    reports: List Report,
    selected: ReportId,
    strategy: ReportStrategy,
    appVersion: String,
    websites: Websites.Model,
    storage: LocalStorage Storage.Msg
  }

initialModel: String -> Model
initialModel appVersion =
  Model [] "" Desktop appVersion Websites.model createStorage
