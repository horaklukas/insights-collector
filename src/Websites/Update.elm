module Websites.Update exposing(..)

import LocalStorage exposing (getItem, setItem, LocalStorage)
import LocalStorage.SharedTypes exposing (Operation(GetItemOperation))
import Json.Encode as Encode
import Json.Decode as Decode

import Storage.Messages as Storage

import Websites.Models exposing (Model)
import Websites.Messages exposing (..)

userWebsitesKey: String
userWebsitesKey = "userWebsites"

encodeWebsitesList: List String -> LocalStorage.SharedTypes.Value
encodeWebsitesList websitesList =
  websitesList 
    |> List.map Encode.string 
    |> Encode.list

decodeWebsitesList: LocalStorage.SharedTypes.Value -> List String
decodeWebsitesList value =
  case Decode.decodeValue (Decode.list Decode.string) value of
    Err msg ->
      []
    Ok websites ->
      websites

isLoadingWebsitesListOperation: Operation -> String -> Bool
isLoadingWebsitesListOperation operation key =
  operation == GetItemOperation && key == userWebsitesKey

update : Msg -> Model -> LocalStorage Storage.Msg -> (Model, Cmd Msg)
update msg model storage =
  case msg of
    Change newContent ->
      ( 
        { model | inputContent = newContent },
        Cmd.none
      )
    LoadUserWebsites ->
      (
        model,
        Cmd.map StorageMsg (getItem storage userWebsitesKey)
      )
    AddWebsite website ->
      let
        newUserWebsites = model.userWebsites ++ [ website ]
      in      
        (
          { model | inputContent = "", userWebsites = newUserWebsites },
          Cmd.map StorageMsg (setItem storage userWebsitesKey (encodeWebsitesList newUserWebsites))
        )
    RemoveWebsite website ->
      let
        newUserWebsites = List.filter (\w -> w /= website) model.userWebsites
      in        
        (
          { model | userWebsites = newUserWebsites },
          Cmd.map StorageMsg (setItem storage userWebsitesKey (encodeWebsitesList newUserWebsites))
        )
    StorageMsg subMsg ->
      case subMsg of
        Storage.UpdatePorts operation ports key value ->
          if isLoadingWebsitesListOperation operation key then
            let
              userWebsites = decodeWebsitesList value
            in
              (
                { model | userWebsites = userWebsites },
                Cmd.none
              )
            else
              ( model, Cmd.none )
        _ ->
          ( model, Cmd.none )
    _ ->
      ( model, Cmd.none )