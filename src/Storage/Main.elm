port module Storage.Main exposing (..)

import LocalStorage
import LocalStorage.SharedTypes exposing(
    ClearPort, 
    GetItemPort, 
    Key, 
    ListKeysPort,  
    Ports, 
    ReceiveItemPort, 
    SetItemPort,
    receiveWrapper)

import Storage.Messages exposing(Msg(..))

prefix: String
prefix =
    "insightsCollector"

ports: Ports Msg
ports =
    LocalStorage.makeRealPorts getItem setItem clear listKeys

port getItem : GetItemPort msg
port setItem : SetItemPort msg
port clear : ClearPort msg
port listKeys : ListKeysPort msg
port receiveItem : ReceiveItemPort msg

createStorage: LocalStorage.LocalStorage Msg
createStorage =
    LocalStorage.make ports prefix
