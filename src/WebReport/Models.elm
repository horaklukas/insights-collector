module WebReport.Models exposing (ReportId, WebUrl, Report, Status (..))

type alias ReportId = String

type alias WebUrl = String

type Status = Fetching | Fetched | Error String

type alias Report =
  {
    id: ReportId,
    webpage: WebUrl,
    status: Status,
    score: Float
  }
