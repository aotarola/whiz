module Update exposing (..)

import Dom
import Task
import String
import Result
import Models exposing (AppState, Product, LineItem)
import Messages exposing (Msg(..))
import Ports
    exposing
        ( searchProduct
        , confirmOrderPurchase
        , showErrorAlert
        , confirmOrderCancel
        )
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
                    ( appState, confirmOrderPurchase "Desea confirmar la venta?" )

        ConfirmOrderPurchase ok ->
            if ok then
                ( { appState | lineItems = [] }, Cmd.none )
            else
                ( appState, Cmd.none )

        ConfirmOrderCancel ok ->
            if ok then
                ( { appState | lineItems = [] }, Cmd.none )
            else
                ( appState, Cmd.none )

        ProductSearchResult value ->
            case decodeProduct value of
                Ok product ->
                    if isPurchasable 1 product then
                        ( { appState
                            | currentProduct = Just <| Debug.log "ProductSearchResult" product
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

                searchForItemRec list x =
                    case list of
                        [] ->
                            Nothing

                        first :: rest ->
                            let
                                ( qty, item ) =
                                    first
                            in
                                if item.code == x.code then
                                    Just item
                                else
                                    searchForItemRec rest x

                checkPurchasability product =
                    case searchForItemRec lineItems product of
                        Just item ->
                            isPurchasable purchaseQuantity item

                        Nothing ->
                            True
            in
                case currentProduct of
                    Just product ->
                        if checkPurchasability product then
                            ( appState
                                |> addToLineItems
                                |> resetSearchView
                            , focusInput "search-by-code"
                            )
                        else
                            ( appState, notEnoughQuantityError )

                    Nothing ->
                        ( appState, Cmd.none )

        UpdateSearchByCode code ->
            ( { appState | codeSearchInput = Just code }, Cmd.none )

        UpdatePurchaseQuantity quantity ->
            case String.toInt quantity of
                Ok result ->
                    ( { appState | purchaseQuantity = max 1 result }, Cmd.none )

                Err _ ->
                    appState ! []

        KeyPressed keyCode ->
            let
                { currentProduct } =
                    appState
            in
                if keyCode == 27 then
                    case currentProduct of
                        Just p ->
                            ( resetSearchView appState, focusInput "search-by-code" )

                        Nothing ->
                            ( appState, confirmOrderCancel "Desea cancelar la venta actual?" )
                else
                    ( appState, Cmd.none )


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
