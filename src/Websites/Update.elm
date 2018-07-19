module Websites.Update exposing(..)

import LocalStorage exposing (getItem, setItem, LocalStorage)
import Json.Decode as Decode
import Json.Encode as Encode

import Storage.Messages as Storage

import Websites.Models exposing (Model)
import Websites.Messages exposing (..)

userWebsitesKey: String
userWebsitesKey = "userWebsites"

update : Msg -> Model -> LocalStorage Storage.Msg -> (Model, Cmd Msg)
update msg model storage =
  case msg of
    Change newContent ->
      ( 
        { model | inputContent = newContent },
        Cmd.none
      )
    AddWebsite website ->
      let
        newUserWebsites = model.userWebsites ++ [ website ]
        encodedWebsites = newUserWebsites 
          |> List.map Encode.string 
          |> Encode.list
      in      
        (
          { model | inputContent = "", userWebsites = newUserWebsites },
          (Cmd.map StorageMsg (setItem storage userWebsitesKey encodedWebsites))
        )
    RemoveWebsite website ->
      (
        { model | userWebsites = ( List.filter (\w -> w /= website) model.userWebsites ) },
        Cmd.none
      )
    _ ->
      ( model, Cmd.none )