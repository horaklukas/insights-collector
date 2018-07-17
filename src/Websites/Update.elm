module Websites.Update exposing(..)

import Websites.Models exposing (Model)
import Websites.Messages exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Change newContent ->
      ( 
        { model | inputContent = newContent },
        Cmd.none
      )
    AddWebsite website ->
      ( 
        { model | inputContent = "", userWebsites = ( model.userWebsites ++ [ website ] ) },
        Cmd.none
      )
    RemoveWebsite website ->
      ( model, Cmd.none )
    _ ->
      ( model, Cmd.none )