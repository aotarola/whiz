module Models exposing (..)


type alias Quantity =
    Int


type alias Product =
    { code : String
    , title : String
    , price : Int
    , idealStock : Int
    , criticalStock : Int
    , currentStock : Int
    , isTaxable : Bool
    }


type alias User =
    { id : String
    , name : String
    }


type alias Store =
    { name : String
    }


type alias LineItem =
    ( Quantity, Product )


type alias AppState =
    { userId : String
    , purchaseQuantity : Int
    , codeSearchInput : String
    , lineItems : List LineItem
    , currentProduct : Maybe Product
    }


unknownUser : User
unknownUser =
    User "N/A" "N/A"


initAppState : AppState
initAppState =
    AppState "160568070" 1 "" [] Nothing
