port module Ports exposing (..)

import Json.Decode exposing (Value)


-- Outgoing ports


port searchProduct : String -> Cmd msg


port confirmOrder : String -> Cmd msg


port showErrorAlert : String -> Cmd msg



-- Incoming ports


port productSearchResult : (Value -> msg) -> Sub msg


port confirmOrderResult : (Bool -> msg) -> Sub msg
