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

                qty_ =
                    Maybe.withDefault 1 purchaseQuantity

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
                            isPurchasable qty_ item

                        Nothing ->
                            True
            in
                if checkPurchasability then
                    let
                        newAppState =
                            { appState | purchaseQuantity = Just qty_ }
                    in
                        ( newAppState
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
                    Result.toMaybe <| String.toInt quantity
            in
                ( { appState | purchaseQuantity = newQuantity }, Cmd.none )

        KeyPressed keyCode ->
            let
                { currentProduct } =
                    appState
            in
                if keyCode == 27 then
                    case currentProduct of
                        Just p ->
                            ( resetSearchView appState, Cmd.none )

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

        updateLineItemsRec qty_ product list =
            case list of
                [] ->
                    [ ( qty_, decreaseProductStock qty_ product ) ]

                first :: rest ->
                    let
                        ( qty, item ) =
                            first
                    in
                        if item.code == product.code then
                            ( qty + qty_, decreaseProductStock qty_ item ) :: rest
                        else
                            first :: updateLineItemsRec qty_ product rest

        updateLineItems qty_ currentProduct =
            case currentProduct of
                Just product ->
                    updateLineItemsRec qty_ product lineItems

                Nothing ->
                    lineItems
    in
        case purchaseQuantity of
            Just qty_ ->
                { appState
                    | lineItems = updateLineItems qty_ currentProduct
                    , purchaseQuantity = Nothing
                }

            Nothing ->
                appState
