module Update exposing (..)

import Dom
import Task
import String
import Result
import Models exposing (AppState, Product, LineItem)
import Messages exposing (Msg(..))
import Ports exposing (searchProduct, confirmOrder, showErrorAlert)
import Decoders exposing (decodeProduct)


update : Msg -> AppState -> ( AppState, Cmd Msg )
update msg appState =
    case msg of
        NoOp ->
            ( appState, Cmd.none )

        SearchProductByCode ->
            case appState.codeSearchInput of
                Just code ->
                    ( appState, searchProduct code )

                Nothing ->
                    ( appState, confirmOrder "Desea confirmar la venta?" )

        ConfirmOrderResult ok ->
            if ok then
                ( { appState | lineItems = [] }, Cmd.none )
            else
                ( appState, Cmd.none )

        ProductSearchResult value ->
            case decodeProduct value of
                Ok product ->
                    if isPurchasable 1 product then
                        ( { appState
                            | currentProduct = Just product
                          }
                        , focusInput "quantity-entry"
                        )
                    else
                        ( appState, notEnoughQuantityError )

                Err _ ->
                    ( appState, Cmd.none )

        UpdateLineItems ->
            let
                { purchaseQuantity, currentProduct, lineItems } =
                    appState

                searchForItem list x =
                    case list of
                        [] ->
                            Nothing

                        first :: rest ->
                            let
                                ( qty, item ) =
                                    first
                            in
                                Just item

                checkPurchasability =
                    case (searchForItem lineItems) currentProduct of
                        Just item ->
                            isPurchasable purchaseQuantity item

                        Nothing ->
                            True
            in
                if checkPurchasability then
                    ( appState
                        |> addToLineItems
                        |> resetSearchView
                    , focusInput "search-by-code"
                    )
                else
                    ( appState, notEnoughQuantityError )

        UpdateSearchByCode code ->
            ( { appState | codeSearchInput = Just code }, Cmd.none )

        UpdatePurchaseQuantity quantity ->
            let
                newQuantity =
                    max 1 <| Result.withDefault 1 <| String.toInt quantity
            in
                ( { appState | purchaseQuantity = newQuantity }, Cmd.none )


notEnoughQuantityError : Cmd Msg
notEnoughQuantityError =
    showErrorAlert "No hay stock suficiente"


isPurchasable : Int -> Product -> Bool
isPurchasable quantity { currentStock } =
    quantity <= currentStock


decreaseProductStock : Int -> Product -> Product
decreaseProductStock decrementQty product =
    { product | currentStock = product.currentStock - decrementQty }


focusInput : String -> Cmd Msg
focusInput id =
    Task.perform (always NoOp) (always NoOp) (Dom.focus id)


resetSearchView : AppState -> AppState
resetSearchView appState =
    { appState
        | codeSearchInput = Nothing
        , currentProduct = Nothing
    }


addToLineItems : AppState -> AppState
addToLineItems appState =
    let
        { lineItems, purchaseQuantity, currentProduct } =
            appState

        updateLineItemsRec product list =
            case list of
                [] ->
                    [ ( purchaseQuantity, decreaseProductStock purchaseQuantity product ) ]

                first :: rest ->
                    let
                        ( qty, item ) =
                            first
                    in
                        if item.code == product.code then
                            ( qty + purchaseQuantity, decreaseProductStock purchaseQuantity item ) :: rest
                        else
                            first :: updateLineItemsRec product rest

        updateLineItems currentProduct =
            case currentProduct of
                Just product ->
                    updateLineItemsRec product lineItems

                Nothing ->
                    lineItems
    in
        { appState
            | lineItems = updateLineItems currentProduct
            , purchaseQuantity = 1
        }
