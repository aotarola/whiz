module Decoders exposing (..)

import Json.Decode as Decode
import Json.Encode exposing (Value)
import Json.Decode.Pipeline as Pipeline
import Models exposing (Product)


productDecoder : Decode.Decoder Product
productDecoder =
    Pipeline.decode Product
        |> Pipeline.required "_id" Decode.string
        |> Pipeline.required "title" Decode.string
        |> Pipeline.required "price" Decode.int
        |> Pipeline.required "idealStock" Decode.int
        |> Pipeline.required "criticalStock" Decode.int
        |> Pipeline.required "currentStock" Decode.int
        |> Pipeline.required "isTaxable" Decode.bool


productListDecoder : Decode.Decoder (List Product)
productListDecoder =
    Decode.list productDecoder


decodeProduct : Value -> Result String Product
decodeProduct =
    Decode.decodeValue productDecoder


decodeProductList : Value -> Result String (List Product)
decodeProductList =
    Decode.decodeValue productListDecoder
