module WebReport.Rule exposing (view)

import Html exposing (Html, div, text, h4, span, a)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Regex exposing (regex, HowMany (..))
import String exposing (left)
import Array

import WebReport.Models exposing (..)
import WebReport.Messages exposing (Msg (..))

view: RuleId -> (RuleId, Rule) -> Html Msg
view activeRule (id, rule) =
  let
    activeClass = if activeRule == id then " expanded" else " collapsed"
  in
    div [class ("panel panel-default rule" ++ activeClass), onClick (SelectRule id)] [
      div [class "panel-heading"] [
        h4 [class "panel-title"] [
          span [class "badge"] [text <| toString <| round rule.impact],
          text rule.name
        ]
      ],
      div [class "panel-body"] (makeRuleSummary rule.summary)--[text (makeRuleSummary rule.summary)]
    ]

makeRuleSummary: RuleSummary -> List (Html Msg)
makeRuleSummary summary =
  case summary.args of
    Just args ->
      let
        pieces = summary.format
          |> Regex.replace All (regex "{{|}}") (\{match} -> match ++ (left 1 match))
          |> Regex.split All (regex "{{|}}")
          |> List.map String.trim
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