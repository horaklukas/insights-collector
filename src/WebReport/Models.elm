module WebReport.Models exposing (Model, Status (..))

type Status = Fetching | Fetched | Error String

type alias Model =
  {
    webpage: String,
    status: Status,
    score: Float
  }
