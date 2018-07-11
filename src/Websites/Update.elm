module Websites.Update exposing(..)

import Websites.Models exposing (Model)

type Msg = Change String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Change newContent ->
      ( { model | inputContent = newContent }, Cmd.none )