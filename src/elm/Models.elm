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
    { lineItems : List LineItem
    , userId : String
    , purchaseQuantity : Maybe Int
    , codeSearchInput : Maybe String
    , currentProduct : Maybe Product
    }


unknownUser : User
unknownUser =
    User "N/A" "N/A"


initAppState : AppState
initAppState =
    AppState [] "160568070" Nothing Nothing Nothing
