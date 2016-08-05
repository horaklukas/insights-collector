module WebReport.Models exposing (ReportId, WebUrl, Report, Status (..), ReportData, PageStats, initialData)

type alias ReportId = String

type alias WebUrl = String

type Status = Fetching | Fetched | Error String

type alias Report = {
  id: ReportId,
  webpage: WebUrl,
  status: Status,
  data: ReportData
}

type alias ReportData = {
  score: Float,
  pageStats: PageStats
}

type alias PageStats = {
  cssResponseBytes: String, -- "51444"
  htmlResponseBytes: String, -- "3615"
  imageResponseBytes: String, -- "32818"
  javascriptResponseBytes: String, -- "135879"
  numberCssResources: Int, -- 4
  --numberHosts: Int, -- 2
  numberJsResources: Int -- 2
  --numberResources: Int, -- 13
  --numberStaticResources: Int, -- 10
  --otherResponseBytes: String, -- "423"
  --totalRequestBytes: String -- "1157"
}

initialData: ReportData
initialData =
  ReportData 0 (PageStats "" "" "" "" 0 0)