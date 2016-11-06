port module Subscriptions exposing (..)

import Models exposing (AppState)
import Messages exposing (Msg(..))
import Ports
    exposing
        ( productSearchResult
        , confirmOrderPurchaseResult
        , confirmOrderCancelResult
        , syncProductUpdates
        )
import Keyboard


subscriptions : AppState -> Sub Msg
subscriptions model =
    Sub.batch
        [ productSearchResult ProductSearchResult
        , confirmOrderPurchaseResult ConfirmOrderPurchase
        , confirmOrderCancelResult ConfirmOrderCancel
        , syncProductUpdates SyncProductUpdates
        , Keyboard.downs KeyPressed
        ]
