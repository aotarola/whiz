module Messages exposing (..)

import Json.Decode exposing (Value)


type Msg
    = NoOp
    | SearchProductByCode
    | UpdateLineItems
    | UpdateSearchByCode String
    | UpdatePurchaseQuantity String
    | ProductSearchResult Value
    | ConfirmOrderResult Bool
