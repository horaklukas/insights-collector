module Storage.Messages exposing (..)

import LocalStorage.SharedTypes
    exposing
        ( Key
        , Operation(..)
        , Ports
        , Value
        , decodeStringList
        )

type Msg
    = GetItem Key
    | SetItem Key Value 
    | ListKeys
    | RemoveItem
    | Clear
    | UpdatePorts Operation (Maybe (Ports Msg)) Key Value