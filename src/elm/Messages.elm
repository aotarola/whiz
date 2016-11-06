module Messages exposing (..)

import Json.Decode exposing (Value)
import Keyboard exposing (KeyCode)


type Msg
    = NoOp
    | SearchProductByCode
    | UpdateLineItems
    | UpdateSearchByCode String
    | UpdatePurchaseQuantity String
    | ProductSearchResult Value
    | ConfirmOrderPurchase Bool
    | ConfirmOrderCancel Bool
    | KeyPressed KeyCode
    | SyncProductUpdates Value
