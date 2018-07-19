module App.Update exposing (update)

import App.Messages exposing (AppMsg (..))
import App.Models exposing (Model)

import WebReport.Main as ReportMain
import WebReport.Messages as ReportMsg
import WebReport.Update as ReportUpdate
import WebReport.Models exposing (..)
import Websites.Update
import Websites.Messages
import Storage.Messages as Storage

update : AppMsg -> Model -> (Model, Cmd AppMsg)
update msg model =
  case msg of
    Webpages webpages ->
      let
        (newReports, cmds) = webpages
          |> List.map (initReport model.strategy)
          |> List.unzip
      in
        (
          { model | reports = newReports },
          Cmd.batch cmds
        )

    WebReportMsg id subMsg ->
      let
        (newReports, cmds) = model.reports
          |> List.map (updateReport id subMsg)
          |> List.unzip
      in
        (
          { model | reports = newReports },
          Cmd.batch cmds
        )
    ChangeStrategy strategy ->
      let
        (newReports, cmds) = model.reports
          |> List.map getWebPage
          |> List.map (initReport strategy)
          |> List.unzip
      in
        (
          { model | strategy = strategy,  reports = newReports },
          Cmd.batch cmds
        )
  
    WebsitesMsg subMsg -> 
      let
        ( updatedWebsitesModel, cmd ) = Websites.Update.update subMsg model.websites model.storage
        websitesCmd = Cmd.map WebsitesMsg cmd
      in
        case subMsg of
          Websites.Messages.AddWebsite website ->
            addWebsites [ website ] { model | websites = updatedWebsitesModel } websitesCmd

          Websites.Messages.SelectWebsite reportId ->
            (
              if isReportFetching model.reports reportId then model
              else { model | selected = reportId },
              websitesCmd
            )
          Websites.Messages.RemoveWebsite reportId ->
              (
                { model | reports = ( List.filter (\r -> r.id /= reportId) model.reports ) },
                websitesCmd
              ) 
          _ ->
            ( 
              { model | websites = updatedWebsitesModel },
              websitesCmd
            )
    AppStorageMsg subMsg ->
      case subMsg of
        Storage.UpdatePorts operation ports key value ->
          let
            ( websitesModel, cmd ) = Websites.Update.update (Websites.Messages.StorageMsg subMsg) model.websites model.storage
            websitesCmd = Cmd.map WebsitesMsg cmd
          in
            if Websites.Update.isLoadingWebsitesListOperation operation key then
                addWebsites websitesModel.userWebsites { model | websites = websitesModel } websitesCmd
            else
              ( { model | websites = websitesModel }, websitesCmd )
        _ ->
          ( model, Cmd.none )

addWebsites: List String -> Model -> Cmd AppMsg -> (Model, Cmd AppMsg)
addWebsites websites model websitesCmd =
  let
    (newReports, cmds) = websites
      |> List.map (initReport model.strategy)
      |> List.unzip
  in
    (
      { model | reports = model.reports ++ newReports },
      Cmd.batch (cmds ++ [ websitesCmd ] )
    )

initReport: ReportStrategy -> WebUrl -> (Report, Cmd AppMsg)
initReport strategy web =
  let
    (report, cmds) = ReportMain.init web strategy
  in
    (
      report,
      Cmd.map (WebReportMsg report.id) cmds
    )

updateReport : ReportId -> ReportMsg.Msg -> Report -> ( Report, Cmd AppMsg )
updateReport id msg report =
  if report.id /= id then
    ( report, Cmd.none )

  else
    let
      ( newReport, cmds ) = ReportUpdate.update msg report
    in
      (
        newReport,
        Cmd.map (WebReportMsg id) cmds
      )

getWebPage: Report -> WebUrl
getWebPage report =
  report.webpage

isReportFetching: List Report -> ReportId -> Bool
isReportFetching reports reportId =
  reports
    |> List.filter (\report -> report.id == reportId)
    |> List.any (\report -> report.status == Fetching)