module Rules.Rule exposing (view, hasImpact)

import Html exposing (Html, div, p, text, h4, span, a, em)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Regex exposing (regex, HowMany (..))
import String exposing (left)
import Array

import WebReport.Messages exposing (Msg (..))
import Rules.Models exposing (RuleId, Rule, FormattedMessage, FormatArg, UrlBlock)

view: RuleId -> (RuleId, Rule) -> Html Msg
view activeRule (id, rule) =
  let
    isActive = activeRule == id
    ruleClassList = [
      ("panel panel-default", True),
      ("rule", True),
      ("rule--complete", not (hasImpact rule.impact)),
      ("expanded", isActive),
      ("collapsed", not isActive)
    ]
  in
    div [classList ruleClassList, onClick (SelectRule id)] [
      div [class "panel-heading"] [
        h4 [class "panel-title"] [
          ruleImpact rule.impact,
          text rule.name
        ]
      ],
      div [class "panel-body"] [
        ruleSummary rule,
        urlBlocks rule
      ]
    ]

hasImpact: Float -> Bool
hasImpact impact =
  (round impact) > 0

ruleImpact: Float -> Html Msg
ruleImpact impact =
  if hasImpact impact then
    span [class "badge"] [text <| toString <| (round impact)]
  else
    span [class "glyphicon glyphicon-ok-circle"] []

ruleSummary: Rule -> Html Msg
ruleSummary rule =
  case rule.summary of
    Just summary ->
      div [class "summary"] (makeMessage summary)

    Nothing ->
      em [] <| [text "No description provided"]


makeMessage: FormattedMessage -> List (Html Msg)
makeMessage summary =
  case summary.args of
    Just args ->
      let
        pieces = summary.format
          |> Regex.replace All (regex "{{|}}") (\{match} -> match ++ (left 1 match))
          |> Regex.split All (regex "{{|}}")
       in
        List.indexedMap (resolvePiece pieces args) pieces

    Nothing ->
      [text summary.format]

resolvePiece: List String -> List FormatArg -> Int -> String -> Html Msg
resolvePiece pieces args pieceIndex piece =
  if String.startsWith "{" piece then
    let
      argKey = stripFirstChar piece
    in
      if argKey == "BEGIN_LINK" then text " "
      else if argKey == "END_LINK" then text " "
      else
        text <| resolveArgValue argKey args

  else if String.startsWith "}" piece then
    let
      prevPiece =
        pieces
          |> Array.fromList
          |> Array.get (pieceIndex - 1)
          |> Maybe.withDefault " "
     in
      if (stripFirstChar prevPiece) == "BEGIN_LINK" then
        a [href <| resolveArgValue "LINK" args] [text (stripFirstChar piece)]
      else
          text <| stripFirstChar piece

  else
    text piece

stripFirstChar: String -> String
stripFirstChar text =
  String.right ((String.length text) - 1) text

resolveArgValue: String -> List FormatArg -> String
resolveArgValue argKey args =
  let
    maybeArg =
      args
        |> List.filter (\arg -> arg.key == argKey)
        |> List.head
  in
    case maybeArg of
      Just arg -> arg.value
      Nothing -> ""

urlBlocks: Rule -> Html Msg
urlBlocks rule =
  case rule.urlBlocks of
    Just blocks ->
      div [class "url-blocks"]  (List.map urlBlock blocks)

    Nothing ->
      text ""

urlBlock: UrlBlock -> Html Msg
urlBlock block =
  let
    headerBlock = blockMessage "header" <| makeMessage block.header
  in
    div [] ( headerBlock :: (urlsBlocks block) )

urlsBlocks: UrlBlock -> List (Html Msg)
urlsBlocks block =
  case block.urls of
    Just urls ->
      urls
        |> List.map makeMessage
        |> List.map (blockMessage "url")

    Nothing ->
      []

blockMessage: String -> List (Html Msg) -> Html Msg
blockMessage className message =
  p [class className] message