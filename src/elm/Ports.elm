port module Ports exposing (..)

import Json.Decode exposing (Value)


-- Outgoing ports


port searchProduct : String -> Cmd msg


port confirmOrderPurchase : String -> Cmd msg


port confirmOrderCancel : String -> Cmd msg


port showErrorAlert : String -> Cmd msg



-- Incoming ports


port productSearchResult : (Value -> msg) -> Sub msg


port confirmOrderPurchaseResult : (Bool -> msg) -> Sub msg


port confirmOrderCancelResult : (Bool -> msg) -> Sub msg
