module Websites.Models exposing (..)

type alias Model =
  {
    inputContent: String,
    userWebsites: List String
  }

model: Model
model =
  Model "" []
