module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (AppState, LineItem, unknownUser)
import Messages exposing (Msg(..))
import Json.Decode as Json


view : AppState -> Html Msg
view appState =
    div []
        [ headerView appState
        , productSearchView appState
        ]


lineItemsView : AppState -> Html Msg
lineItemsView { lineItems } =
    ul [ id "lineitems" ] (List.map lineItemsRowView lineItems)


lineItemsRowView : LineItem -> Html Msg
lineItemsRowView ( quantity, product ) =
    li [] [ text product.title, text " ", text <| toString quantity ]


productSearchView : AppState -> Html Msg
productSearchView appState =
    let
        { codeSearchInput } =
            appState
    in
        div []
            (productEntryView appState ++ [ lineItemsView appState ])


productEntryView : AppState -> List (Html Msg)
productEntryView appState =
    let
        { codeSearchInput, currentProduct } =
            appState
    in
        case currentProduct of
            Just product ->
                [ div []
                    [ strong [] [ text "producto" ] ]
                , div [ id "product-info" ]
                    [ text product.title
                    , text " | "
                    , text <| toString product.price
                    , text " | "
                    , input
                        [ id "quantity-entry"
                        , type' "number"
                        , onInput UpdatePurchaseQuantity
                        , onEnter <| UpdateLineItems
                        ]
                        []
                    ]
                ]

            Nothing ->
                [ div []
                    [ strong [] [ text "codigo barra" ] ]
                , div []
                    [ input
                        [ id "search-by-code"
                        , type' "text"
                        , autofocus True
                        , onInput UpdateSearchByCode
                        , value codeSearchInput
                        , onEnter SearchProductByCode
                        ]
                        []
                    , button
                        [ id
                            "btn-search"
                        , onClick SearchProductByCode
                        ]
                        [ text "buscar" ]
                    ]
                ]


headerView : AppState -> Html Msg
headerView appState =
    div []
        [ p [] [ text "Bienvenid(a), ", getUserNameView appState, text " a nuestra sucursal ", getStoreNameView appState ]
        , p [] [ text "Fecha inicio turno: Tuesday 25 October 2016 - 04:00:57" ]
        , p [] [ text "Última venta registrada: No ha registrado ninguna venta." ]
        ]


getUserNameView : AppState -> Html Msg
getUserNameView appState =
    strong [] [ text "Andres" ]


getStoreNameView : AppState -> Html Msg
getStoreNameView appState =
    strong [] [ text "Playa Brava" ]


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        tagger code =
            if code == 13 then
                msg
            else
                NoOp
    in
        on "keydown" (Json.map tagger keyCode)
