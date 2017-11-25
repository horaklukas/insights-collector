module WebReport.Url exposing (makeUrl, Url)

import Erl

type alias Url = String

type alias Param = (String, String)

googleApiUrl: Erl.Url
googleApiUrl = Erl.parse "https://www.googleapis.com/pagespeedonline/v2/runPagespeed"

makeUrl: String -> String -> Url
makeUrl website strategy =
  googleApiUrl
    |> Erl.setQuery "url" (checkWebsite website)
    |> Erl.addQuery "strategy" strategy
    |> Erl.addQuery "screenshot" "true"
    |> Erl.toString

checkWebsite: String -> Url
checkWebsite website =
  let
    url = Erl.parse website
  in
    if url.protocol == "" then "http://" ++ website
    else website

makeUrlParam: Param -> String
makeUrlParam (paramName, value) =
  paramName ++ "=" ++ value


