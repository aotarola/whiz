port module Subscriptions exposing (..)

import Models exposing (AppState)
import Messages exposing (Msg(..))
import Ports exposing (productSearchResult, confirmOrderResult)


subscriptions : AppState -> Sub Msg
subscriptions model =
    Sub.batch
        [ productSearchResult ProductSearchResult
        , confirmOrderResult ConfirmOrderResult
        ]
